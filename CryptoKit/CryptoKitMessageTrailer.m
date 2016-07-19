//
//  CryptoKitMessageTrailer.m
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import <CryptoKit/CryptoKitErrors.h>

#import "CryptoKitMessageHeader.h"
#import "CryptoKitMessageTrailer.h"

#import "NSOutputStream+CryptoKitPrivate.h"

const uint32_t CryptoKitTrailerEncryptionAlgorithm = kCCAlgorithmAES;
const uint32_t CryptoKitTrailerEncryptionPadding = kCCOptionPKCS7Padding;

extern NSString *NSStringFromCCStatus(CCStatus status);

@implementation CryptoKitMessageTrailer

- (void)encryptPayloadDigestAndWriteToOutputStream:(NSOutputStream *)outputStream
                              initializationVector:(NSData *)initializationVector
                                               key:(NSData *)key
                                    digestChecksum:(NSData *)checksum
{
    NSAssert(outputStream, @"OutputStream must not be nil");
    NSAssert(initializationVector, @"InitializationVector must not be nil");
    NSAssert(key, @"Key must not be nil");
    NSAssert(checksum, @"Checksum must not be nil");
    NSData *encryptedDigest = [self cryptData:checksum
                         initializationVector:initializationVector
                                          key:key
                                    operation:kCCEncrypt];
    [outputStream blockingWriteData:encryptedDigest];
}

- (void)decryptPayloadDigestAndVerify:(NSData *)encryptedDigest
                 initializationVector:(NSData *)initializationVector
                                  key:(NSData *)key
                       expectedDigest:(NSData *)expectedDigest
{
    NSAssert(encryptedDigest, @"Encrypted digest must not be nil");
    NSAssert(initializationVector, @"InitializationVector must not be nil");
    NSAssert(key, @"Key must not be nil");
    NSAssert(expectedDigest, @"Expected digest must not be nil");
    NSData *decryptedBodyDigestFromStream = [self cryptData:encryptedDigest
                                       initializationVector:initializationVector
                                                        key:key
                                                  operation:kCCDecrypt];
    [self verifyChecksum:decryptedBodyDigestFromStream
          expectedDigest:expectedDigest];
}

- (NSData *)cryptData:(NSData *)data
 initializationVector:(NSData *)initializationVector
                  key:(NSData *)key
            operation:(CCOperation)operation
{
    NSUInteger capacity = (NSUInteger)([data length] / CryptoKitInitializationVectorBlockSize + 1) * CryptoKitInitializationVectorBlockSize;
    NSMutableData *encryptedData = [NSMutableData dataWithLength:capacity];
    size_t dataOutMoved = 0;
    CCCryptorStatus status = CCCrypt(operation,
                                     CryptoKitTrailerEncryptionAlgorithm,
                                     CryptoKitTrailerEncryptionPadding,
                                     [key bytes],
                                     [key length],
                                     [initializationVector bytes],
                                     [data bytes],
                                     [data length],
                                     [encryptedData mutableBytes],
                                     [encryptedData length],
                                     &dataOutMoved);
    if (status != kCCSuccess) {
        NSString *reason = [NSString stringWithFormat:@"Crypto operation failed: %@",
                                                      NSStringFromCCStatus(status)];
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:reason
                                     userInfo:@{ @"errorCode": @(CryptoKitInternalError) }];
    }
    if (dataOutMoved < [encryptedData length]) {
        [encryptedData setLength:dataOutMoved];
    }
    return encryptedData;
}

- (void)verifyChecksum:(NSData *)expectedCheckSum
        expectedDigest:(NSData *)expectedDigest
{
    if (![expectedCheckSum isEqual:expectedDigest]) {
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:@"Payload checksum invalid"
                                     userInfo:@{ @"errorCode": @(CryptoKitPayloadChecksumMismatch) }];
    }
}

@end
