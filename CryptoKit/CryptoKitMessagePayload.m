//
//  CryptoKitMessagePayload.m
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import <CryptoKit/CryptoKitErrors.h>

#import "CryptoKitMessageHeader.h"
#import "CryptoKitMessagePayload.h"
#import "CryptoKitTypes.h"

#import "NSInputStream+CryptoKitPrivate.h"
#import "NSOutputStream+CryptoKitPrivate.h"

const uint32_t CryptoKitPayloadEncryptionStreamBufferSize = 1024;
const uint32_t CryptoKitPayloadEncryptionAlgorithm = kCCAlgorithmAES;
const uint32_t CryptoKitPayloadEncryptionPadding = kCCOptionPKCS7Padding;

@implementation CryptoKitMessagePayload

@synthesize payloadDigest = _payloadDigest;

- (void)encryptDataFromInputStream:(NSInputStream *)inputStream
                      outputStream:(NSOutputStream *)outputStream
          withInitializationVector:(NSData *)initializationVector
                           withKey:(NSData *)key
{
    NSAssert(inputStream, @"InputStream must not be nil");
    NSAssert(outputStream, @"OutputStream must not be nil");
    NSAssert(initializationVector, @"InitializationVector must not be nil");
    NSAssert(key, @"Key must not be nil");
    CCCryptorRef cryptor = nil;
    @try {
        CC_SHA512_CTX __block ctx = {};
        CC_SHA512_Init(&ctx);
        cryptor = [self createCryptor:kCCEncrypt
                 initializationVector:initializationVector
                                  key:key];
        size_t outputStreamBufferSize = CCCryptorGetOutputLength(cryptor, CryptoKitPayloadEncryptionStreamBufferSize, true);
        NSMutableData *inBuffer = [NSMutableData dataWithLength:CryptoKitPayloadEncryptionStreamBufferSize];
        NSMutableData *outBuffer = [NSMutableData dataWithLength:outputStreamBufferSize];
        [inputStream consumeDataIntoBuffer:inBuffer
                                  callback:^(NSUInteger bytesRead) {
                                    size_t dataMovedLength = 0;
                                    CCCryptorStatus cryptorResult = CCCryptorUpdate(cryptor,
                                                                                    [inBuffer bytes],
                                                                                    bytesRead,
                                                                                    [outBuffer mutableBytes],
                                                                                    outputStreamBufferSize,
                                                                                    &dataMovedLength);
                                    CC_SHA512_Update(&ctx, [inBuffer bytes], (CC_LONG)bytesRead);
                                    [self processCryptorResult:cryptorResult
                                                  outputStream:outputStream
                                             destinationBuffer:outBuffer
                                               dataMovedLength:dataMovedLength];
                                  }];
        size_t dataMovedLength = 0;
        CCCryptorStatus cryptorResult = CCCryptorFinal(cryptor,
                                                       [outBuffer mutableBytes],
                                                       outputStreamBufferSize,
                                                       &dataMovedLength);
        [self processCryptorResult:cryptorResult
                      outputStream:outputStream
                 destinationBuffer:outBuffer
                   dataMovedLength:dataMovedLength];
        NSMutableData *payloadDigest = [NSMutableData dataWithLength:CryptoKitDigestTypeSize(CryptoKitDigestTypeSHA512)];
        CC_SHA512_Final([payloadDigest mutableBytes], &ctx);
        self.payloadDigest = payloadDigest;
    } @finally {
        if (cryptor) {
            CCCryptorRelease(cryptor);
        }
    }
}

- (NSData *)decryptDataFromInputStream:(NSInputStream *)inputStream
                          outputStream:(NSOutputStream *)outputStream
              withInitializationVector:(NSData *)initializationVector
                               withKey:(NSData *)key
{
    NSAssert(inputStream, @"InputStream must not be nil");
    NSAssert(outputStream, @"OutputStream must not be nil");
    NSAssert(initializationVector, @"InitializationVector must not be nil");
    NSAssert(key, @"Key must not be nil");
    const NSUInteger bodyChecksumSize = CryptoKitDigestTypeSize(CryptoKitDigestTypeSHA512) + CryptoKitInitializationVectorBlockSize;
    CCCryptorRef cryptor = nil;
    @try {
        CC_SHA512_CTX __block ctx = {};
        CC_SHA512_Init(&ctx);
        cryptor = [self createCryptor:kCCDecrypt
                 initializationVector:initializationVector
                                  key:key];
        size_t outputStreamBufferSize = CCCryptorGetOutputLength(cryptor, CryptoKitPayloadEncryptionStreamBufferSize, true);
        NSMutableData *inBuffer = [NSMutableData dataWithLength:CryptoKitPayloadEncryptionStreamBufferSize];
        NSMutableData *outBuffer = [NSMutableData dataWithLength:outputStreamBufferSize];
        NSData *previousRound = nil, *data = nil, *encryptedPayloadDigestFromStream = nil;
        // due to the nature of stream processing and the encryption data format (especially the payload checksum
        // in the trailer), all received data has to be buffered for two loop-iterations.
        // in the first step, data is received, checked for size and buffered.
        // in the second step, data is either piped directly into the crypto and hash engines or partitioned,
        // so that the payload checksum in the trailer is not used in the decryption operation and kept only for
        // validation later on
        for (;;) {
            BOOL done = NO;
            NSInteger bytesRead = [inputStream read:[inBuffer mutableBytes]
                                          maxLength:[inBuffer length]];
            if (bytesRead < 0) {
                @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                               reason:@"Read operation on input-stream failed"
                                             userInfo:@{ @"errorCode": @(CryptoKitIOError) }];
            } else if (bytesRead == 0) {
                if (!previousRound) {
                    @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                                   reason:@"Payload is empty"
                                                 userInfo:@{ @"errorCode": @(CryptoKitPayloadChecksumMismatch) }];
                }
                NSUInteger dataLength = [previousRound length] - bodyChecksumSize;
                NSRange lastRoundDataRange = NSMakeRange(0, dataLength);
                data = [previousRound subdataWithRange:lastRoundDataRange];
                NSRange lastRoundChecksumRange = NSMakeRange(dataLength, bodyChecksumSize);
                encryptedPayloadDigestFromStream = [previousRound subdataWithRange:lastRoundChecksumRange];
                done = YES;
            } else if ((NSUInteger)bytesRead < [inBuffer length]) {
                if ((NSUInteger)bytesRead < bodyChecksumSize) {
                    if (!previousRound) {
                        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                                       reason:@"Payload is truncated"
                                                     userInfo:@{ @"errorCode": @(CryptoKitPayloadChecksumMismatch) }];
                    }
                    NSUInteger lastRoundChecksumSize = bodyChecksumSize - (NSUInteger)bytesRead;
                    NSRange lastRoundDataRange = NSMakeRange(0, [previousRound length] - lastRoundChecksumSize);
                    data = [previousRound subdataWithRange:lastRoundDataRange];
                    NSMutableData *localDigest = [NSMutableData dataWithLength:bodyChecksumSize];
                    NSRange lastRoundChecksumRange = NSMakeRange([previousRound length] - lastRoundChecksumSize, lastRoundChecksumSize);
                    NSData *lastRoundChecksumPart = [previousRound subdataWithRange:lastRoundChecksumRange];
                    NSRange digestChecksumRangeForLastRound = NSMakeRange(0, lastRoundChecksumSize);
                    [localDigest replaceBytesInRange:digestChecksumRangeForLastRound
                                           withBytes:[lastRoundChecksumPart bytes]];
                    NSRange digestChecksumRangeForInBuffer = NSMakeRange(lastRoundChecksumSize, (NSUInteger)bytesRead);
                    [localDigest replaceBytesInRange:digestChecksumRangeForInBuffer
                                           withBytes:[inBuffer bytes]];
                    previousRound = localDigest;
                } else {
                    data = previousRound;
                    NSRange inBufferSizeRange = NSMakeRange(0, (NSUInteger)bytesRead);
                    previousRound = [inBuffer subdataWithRange:inBufferSizeRange];
                }
            } else {
                data = previousRound;
                previousRound = [NSData dataWithData:inBuffer];
            }
            if (data) {
                size_t dataMovedLength = 0;
                CCCryptorStatus cryptorResult = CCCryptorUpdate(cryptor,
                                                                [data bytes],
                                                                [data length],
                                                                [outBuffer mutableBytes],
                                                                outputStreamBufferSize,
                                                                &dataMovedLength);
                CC_SHA512_Update(&ctx, [outBuffer bytes], (CC_LONG)dataMovedLength);
                [self processCryptorResult:cryptorResult
                              outputStream:outputStream
                         destinationBuffer:outBuffer
                           dataMovedLength:dataMovedLength];
                data = nil;
            }
            if (done) {
                break;
            }
        }
        size_t dataMovedLength = 0;
        CCCryptorStatus cryptorResult = CCCryptorFinal(cryptor,
                                                       [outBuffer mutableBytes],
                                                       outputStreamBufferSize,
                                                       &dataMovedLength);
        [self processCryptorResult:cryptorResult
                      outputStream:outputStream
                 destinationBuffer:outBuffer
                   dataMovedLength:dataMovedLength];
        CC_SHA512_Update(&ctx, [outBuffer bytes], (CC_LONG)dataMovedLength);
        NSMutableData *payloadDigest = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
        CC_SHA512_Final([payloadDigest mutableBytes], &ctx);
        self.payloadDigest = payloadDigest;
        return encryptedPayloadDigestFromStream;
    } @finally {
        if (cryptor) {
            CCCryptorRelease(cryptor);
        }
    }
}

#pragma mark - Helpers

- (CCCryptorRef)createCryptor:(CCOperation)operation
         initializationVector:(NSData *)initializationVector
                          key:(NSData *)key
{
    CCCryptorRef cryptor = nil;
    CCCryptorStatus result = CCCryptorCreate(operation,
                                             CryptoKitPayloadEncryptionAlgorithm,
                                             CryptoKitPayloadEncryptionPadding,
                                             [key bytes],
                                             [key length],
                                             [initializationVector bytes],
                                             &cryptor);

    if (result != kCCSuccess) {
        NSString *reason = [NSString stringWithFormat:@"Crypto operation failed: %@",
                                                      NSStringFromCCStatus(result)];
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:reason
                                     userInfo:@{ @"errorCode": @(CryptoKitInternalError) }];
    }
    return cryptor;
}

- (void)processCryptorResult:(CCCryptorStatus)cryptorStatus
                outputStream:(NSOutputStream *)outputStream
           destinationBuffer:(NSData *)destinationBuffer
             dataMovedLength:(size_t)dataMovedLength
{
    if (cryptorStatus != kCCSuccess) {
        NSString *reason = [NSString stringWithFormat:@"Crypto operation failed: %@",
                                                      NSStringFromCCStatus(cryptorStatus)];
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:reason
                                     userInfo:@{ @"errorCode": @(CryptoKitInternalError) }];
    }
    if (dataMovedLength > 0) {
        NSData *movedData = [destinationBuffer subdataWithRange:NSMakeRange(0, dataMovedLength)];
        [outputStream blockingWriteData:movedData];
    }
}

@end
