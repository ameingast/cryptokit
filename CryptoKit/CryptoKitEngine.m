//
//  CryptoKitEngine.m
//  CryptoKit
//
//  Created by Andreas Meingast on 09/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CryptoKit/CryptoKitEngine.h>

extern int errno;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Errors

NSString *const CryptoKitErrorDomain = @"com.operationalsemantics.CryptoKit";

#pragma mark - Configuration

const uint32_t CryptoKitKeyGeneratorRounds = 100000;
const uint32_t CryptoKitStreamBufferSize = 1024;
const uint32_t CryptoKitSerializationVersion = 1;
const uint32_t CryptoKitHeaderPaddingSize = 172;
const uint32_t CryptoKitKeySize = kCCKeySizeAES256;
const uint32_t CryptoKitSaltSize = 64;
const uint32_t CryptoKitInitializationVectorBlockSize = kCCBlockSizeAES128;
const uint32_t CryptoKitEncryptionAlgorithm = kCCAlgorithmAES;
const uint32_t CryptoKitEncryptionPadding = kCCOptionPKCS7Padding;

#pragma mark - Digests

NSUInteger CryptoKitDigestTypeSize(CryptoKitDigestType type);
NSData *CryptoKitCreateDigestFromInputStream(NSInputStream *inputStream,
                                             CryptoKitDigestType);
void CryptoKitDigestTypeAssert(CryptoKitDigestType digestType);

#pragma mark - Keys

NSData *NSDataWithRandomBytes(size_t length);
NSData *NSDataWithKey(NSString *password,
                      NSData *salt,
                      CCPBKDFAlgorithm pseudoRandomAlgorithm);

#pragma mark - NSStream Encryption

void CryptoKitWriteDataToStream(NSOutputStream *outputStream,
                                NSData *data);
NSData *CryptoKitReadDataFromStream(NSInputStream *inputStream,
                                    NSUInteger length);
CCCryptorRef CryptoKitCreateCryptor(CCOperation operation,
                                    NSData *initializationVector,
                                    NSData *key);
void CryptoKitProcessCryptorResult(CCCryptorRef cryptor,
                                   CCCryptorStatus cryptorUpdateResult,
                                   NSOutputStream *outputStream,
                                   NSData *destinationBuffer,
                                   size_t dataMovedLength);
void CryptoKitPerformCCOperation(NSInputStream *inputStream,
                                 NSOutputStream *outputStream,
                                 CCOperation operation,
                                 NSString *password);

NSData *CryptoKitCreateVersionData(uint32_t version);
uint32_t CryptoKitReadVersionData(NSData *data);

#pragma mark - Helpers

NSString *NSStringFromCCStatus(CCStatus status);
void CryptoKitConsumeDataFromInputStream(NSInputStream *inputStream,
                                         NSMutableData *buffer,
                                         void (^callback)(NSInteger bytesRead));
NSError *NSErrorFromException(NSException *exception);

NS_ASSUME_NONNULL_END

#pragma mark - Digests

inline NSData *NSDataWithDigestFromInputStream(NSInputStream *inputStream,
                                               CryptoKitDigestType digestType,
                                               NSError *__autoreleasing *error)
{
    NSCAssert(inputStream, @"InputStream must not be nil");
    CryptoKitDigestTypeAssert(digestType);
    @try {
        NSData *result = CryptoKitCreateDigestFromInputStream(inputStream, digestType);
        return result;
    } @catch (NSException *exception) {
        if (error) {
            *error = NSErrorFromException(exception);
        }
    }
}

inline NSData *CryptoKitCreateDigestFromInputStream(NSInputStream *inputStream,
                                                    CryptoKitDigestType digestType)
{
    NSUInteger digestSize = CryptoKitDigestTypeSize(digestType);
    NSMutableData *digestData = [NSMutableData dataWithLength:digestSize];
    NSMutableData *buffer = [NSMutableData dataWithLength:CryptoKitStreamBufferSize];
    switch (digestType) {
        case CryptoKitDigestTypeMD2: {
            CC_MD2_CTX __block ctx;
            CC_MD2_Init(&ctx);
            CryptoKitConsumeDataFromInputStream(inputStream, buffer, ^(NSInteger bytesRead) {
              CC_MD2_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
            });
            CC_MD2_Final([digestData mutableBytes], &ctx);
            break;
        }
        case CryptoKitDigestTypeMD4: {
            CC_MD4_CTX __block ctx;
            CC_MD4_Init(&ctx);
            CryptoKitConsumeDataFromInputStream(inputStream, buffer, ^(NSInteger bytesRead) {
              CC_MD4_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
            });
            CC_MD4_Final([digestData mutableBytes], &ctx);
            break;
        }
        case CryptoKitDigestTypeMD5: {
            CC_MD5_CTX __block ctx;
            CC_MD5_Init(&ctx);
            CryptoKitConsumeDataFromInputStream(inputStream, buffer, ^(NSInteger bytesRead) {
              CC_MD5_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
            });
            CC_MD5_Final([digestData mutableBytes], &ctx);
            break;
        }
        case CryptoKitDigestTypeSHA1: {
            CC_SHA1_CTX __block ctx;
            CC_SHA1_Init(&ctx);
            CryptoKitConsumeDataFromInputStream(inputStream, buffer, ^(NSInteger bytesRead) {
              CC_SHA1_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
            });
            CC_SHA1_Final([digestData mutableBytes], &ctx);
            break;
        }
        case CryptoKitDigestTypeSHA224: {
            CC_SHA256_CTX __block ctx;
            CC_SHA224_Init(&ctx);
            CryptoKitConsumeDataFromInputStream(inputStream, buffer, ^(NSInteger bytesRead) {
              CC_SHA224_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
            });
            CC_SHA224_Final([digestData mutableBytes], &ctx);
            break;
        }
        case CryptoKitDigestTypeSHA384: {
            CC_SHA512_CTX __block ctx;
            CC_SHA384_Init(&ctx);
            CryptoKitConsumeDataFromInputStream(inputStream, buffer, ^(NSInteger bytesRead) {
              CC_SHA384_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
            });
            CC_SHA384_Final([digestData mutableBytes], &ctx);
            break;
        }
        case CryptoKitDigestTypeSHA512: {
            CC_SHA512_CTX __block ctx;
            CC_SHA512_Init(&ctx);
            CryptoKitConsumeDataFromInputStream(inputStream, buffer, ^(NSInteger bytesRead) {
              CC_SHA512_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
            });
            CC_SHA512_Final([digestData mutableBytes], &ctx);
            break;
        }
    }
    return digestData;
}

inline NSString *NSStringAsDigestFromData(NSData *data,
                                          CryptoKitDigestType digestType)
{
    NSCAssert(data, @"Data must not be nil");
    CryptoKitDigestTypeAssert(digestType);
    unsigned char *bytes = (unsigned char *)[data bytes];
    NSUInteger digestLength = CryptoKitDigestTypeSize(digestType);
    NSMutableString *result = [NSMutableString stringWithCapacity:digestLength * 2];
    for (NSUInteger i = 0; i < digestLength; i++) {
        [result appendFormat:@"%02x", bytes[i]];
    }
    return result;
}

inline NSUInteger CryptoKitDigestTypeSize(CryptoKitDigestType digestType)
{
    CryptoKitDigestTypeAssert(digestType);
    switch (digestType) {
        case CryptoKitDigestTypeMD2:
            return CC_MD2_DIGEST_LENGTH;
        case CryptoKitDigestTypeMD4:
            return CC_MD4_DIGEST_LENGTH;
        case CryptoKitDigestTypeMD5:
            return CC_MD5_DIGEST_LENGTH;
        case CryptoKitDigestTypeSHA1:
            return CC_SHA1_DIGEST_LENGTH;
        case CryptoKitDigestTypeSHA224:
            return CC_SHA224_DIGEST_LENGTH;
        case CryptoKitDigestTypeSHA384:
            return CC_SHA384_DIGEST_LENGTH;
        case CryptoKitDigestTypeSHA512:
            return CC_SHA512_DIGEST_LENGTH;
    }
}

inline void CryptoKitDigestTypeAssert(CryptoKitDigestType digestType)
{
    NSCAssert(digestType == CryptoKitDigestTypeMD2 ||
                  digestType == CryptoKitDigestTypeMD4 ||
                  digestType == CryptoKitDigestTypeMD5 ||
                  digestType == CryptoKitDigestTypeSHA1 ||
                  digestType == CryptoKitDigestTypeSHA224 ||
                  digestType == CryptoKitDigestTypeSHA384 ||
                  digestType == CryptoKitDigestTypeSHA512,
              @"Invalid digestType: %ld", digestType);
}

#pragma mark - NSStream Encryption

inline BOOL CryptoKitEncryptStream(NSInputStream *inputStream,
                                   NSOutputStream *outputStream,
                                   NSString *password,
                                   NSError **error)
{
    @try {
        CryptoKitPerformCCOperation(inputStream, outputStream, kCCEncrypt, password);
        return YES;
    } @catch (NSException *exception) {
        if (error) {
            *error = NSErrorFromException(exception);
        }
        return NO;
    }
}

inline BOOL CryptoKitDecryptStream(NSInputStream *inputStream,
                                   NSOutputStream *outputStream,
                                   NSString *password,
                                   NSError **error)
{
    @try {
        CryptoKitPerformCCOperation(inputStream, outputStream, kCCDecrypt, password);
        return YES;
    } @catch (NSException *exception) {
        if (error) {
            *error = NSErrorFromException(exception);
        }
        return NO;
    }
}

inline void CryptoKitWriteDataToStream(NSOutputStream *outputStream,
                                       NSData *data)
{
    NSInteger bytesWritten = [outputStream write:[data bytes]
                                       maxLength:[data length]];
    if (bytesWritten < 0 || (NSUInteger)bytesWritten != [data length]) {
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:@"Unable to write data to stream"
                                     userInfo:@{ @"errorCode": @(CryptoKitIOError) }];
    }
}

inline NSData *CryptoKitReadDataFromStream(NSInputStream *inputStream,
                                           NSUInteger length)
{
    NSMutableData *data = [NSMutableData dataWithLength:length];
    NSInteger bytesRead = [inputStream read:[data mutableBytes]
                                  maxLength:[data length]];
    if (bytesRead < 0 || (NSUInteger)bytesRead != [data length]) {
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:@"Unable to read data from stream"
                                     userInfo:@{ @"errorCode": @(CryptoKitIOError) }];
    }
    return data;
}

inline CCCryptorRef CryptoKitCreateCryptor(CCOperation operation,
                                           NSData *initializationVector,
                                           NSData *key)
{
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus result = CCCryptorCreate(operation,
                                             CryptoKitEncryptionAlgorithm,
                                             CryptoKitEncryptionPadding,
                                             [key bytes],
                                             [key length],
                                             [initializationVector bytes],
                                             &cryptor);

    if (result != kCCSuccess) {
        NSString *reason = [NSString stringWithFormat:@"Unable to create cryptor: %@",
                                                      NSStringFromCCStatus(result)];
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:reason
                                     userInfo:@{ @"errorCode": @(CryptoKitInternalError) }];
    }
    return cryptor;
}

inline void CryptoKitProcessCryptorResult(CCCryptorRef cryptor,
                                          CCCryptorStatus cryptorStatus,
                                          NSOutputStream *outputStream,
                                          NSData *destinationBuffer,
                                          size_t dataMovedLength)
{
    if (cryptorStatus != kCCSuccess) {
        CCCryptorRelease(cryptor);
        NSString *reason = [NSString stringWithFormat:@"Unable to perform crypto operation on stream: %@",
                                                      NSStringFromCCStatus(cryptorStatus)];
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:reason
                                     userInfo:@{ @"errorCode": @(CryptoKitInternalError) }];
    }
    if (dataMovedLength > 0) {
        NSInteger bytesWritten = [outputStream write:[destinationBuffer bytes]
                                           maxLength:dataMovedLength];
        if (bytesWritten < 0 || (NSUInteger)bytesWritten != dataMovedLength) {
            CCCryptorRelease(cryptor);
            @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                           reason:@"Unable to write data to stream"
                                         userInfo:@{ @"errorCode": @(CryptoKitIOError) }];
        }
    }
}

inline NSData *CryptoKitCreateVersionData(uint32_t version)
{
    NSData *result = [NSData dataWithBytes:&version
                                    length:sizeof(uint32_t)];
    return result;
}

inline uint32_t CryptoKitReadVersionData(NSData *data)
{
    uint32_t version;
    [data getBytes:&version
            length:sizeof(uint32_t)];
    return version;
}

inline void CryptoKitPerformCCOperation(NSInputStream *inputStream,
                                        NSOutputStream *outputStream,
                                        CCOperation operation,
                                        NSString *password)
{
    NSCAssert(inputStream, @"InputStream must not be nil");
    NSCAssert(outputStream, @"OutputStream must not be nil");
    NSCAssert(password, @"Password must not be nil");
    NSData *initializationVector = NULL, *salt = NULL, *version, *padding = NULL;
    switch (operation) {
        case kCCEncrypt: {
            initializationVector = NSDataWithRandomBytes(CryptoKitInitializationVectorBlockSize);
            salt = NSDataWithRandomBytes(CryptoKitSaltSize);
            version = CryptoKitCreateVersionData(CryptoKitSerializationVersion);
            padding = [NSMutableData dataWithLength:CryptoKitHeaderPaddingSize];
            CryptoKitWriteDataToStream(outputStream, version);
            CryptoKitWriteDataToStream(outputStream, initializationVector);
            CryptoKitWriteDataToStream(outputStream, salt);
            CryptoKitWriteDataToStream(outputStream, padding);
            break;
        }
        case kCCDecrypt: {
            version = CryptoKitReadDataFromStream(inputStream, sizeof(uint32_t));
            (void)CryptoKitReadVersionData(version);
            initializationVector = CryptoKitReadDataFromStream(inputStream, CryptoKitInitializationVectorBlockSize);
            salt = CryptoKitReadDataFromStream(inputStream, CryptoKitSaltSize);
            (void)CryptoKitReadDataFromStream(inputStream, CryptoKitHeaderPaddingSize);
            break;
        }
        default: {
            @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                           reason:@"Invalid crypto operation"
                                         userInfo:@{ @"errorCode": @(CryptoKitInternalError) }];
        }
    }
    NSData *key = NSDataWithKey(password, salt, kCCPRFHmacAlgSHA512);
    CCCryptorRef cryptor = CryptoKitCreateCryptor(operation, initializationVector, key);
    size_t outputStreamBufferSize = CCCryptorGetOutputLength(cryptor, CryptoKitStreamBufferSize, true);
    NSMutableData *inBuffer = [NSMutableData dataWithLength:CryptoKitStreamBufferSize];
    NSMutableData *outBuffer = [NSMutableData dataWithLength:outputStreamBufferSize];
    CryptoKitConsumeDataFromInputStream(inputStream, inBuffer, ^(NSInteger bytesRead) {
      size_t dataMovedLength = 0;
      CCCryptorStatus cryptorResult = CCCryptorUpdate(cryptor,
                                                      [inBuffer bytes],
                                                      (NSUInteger)bytesRead,
                                                      [outBuffer mutableBytes],
                                                      outputStreamBufferSize,
                                                      &dataMovedLength);
      CryptoKitProcessCryptorResult(cryptor, cryptorResult, outputStream, outBuffer, dataMovedLength);
    });
    size_t dataMovedLength = 0;
    CCCryptorStatus cryptorResult = CCCryptorFinal(cryptor,
                                                   [outBuffer mutableBytes],
                                                   outputStreamBufferSize,
                                                   &dataMovedLength);
    CryptoKitProcessCryptorResult(cryptor, cryptorResult, outputStream, outBuffer, dataMovedLength);
    CCCryptorRelease(cryptor);
}

#pragma mark - Encryption Helpers

inline NSData *NSDataWithRandomBytes(size_t length)
{
    NSMutableData *data = [NSMutableData dataWithLength:length];
    NSInteger result = SecRandomCopyBytes(kSecRandomDefault, [data length], [data mutableBytes]);
    if (result == -1) {
        NSString *reason = [NSString stringWithFormat:@"Unable to generate random bytes: %s",
                                                      strerror(errno)];
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:reason
                                     userInfo:@{ @"errorCode": @(CryptoKitInternalError) }];
    }
    return data;
}

inline NSData *NSDataWithKey(NSString *password,
                             NSData *salt,
                             CCPBKDFAlgorithm pseudoRandomAlgorithm)
{
    NSCAssert(password, @"Password must not be nil");
    NSCAssert(salt, @"Salt must not be nil");
    NSMutableData *key = [NSMutableData dataWithLength:CryptoKitKeySize];
    CCCryptorStatus result = CCKeyDerivationPBKDF(kCCPBKDF2,
                                                  [password UTF8String],
                                                  [password length],
                                                  [salt bytes],
                                                  [salt length],
                                                  pseudoRandomAlgorithm,
                                                  CryptoKitKeyGeneratorRounds,
                                                  [key mutableBytes],
                                                  [key length]);
    if (result != kCCSuccess) {
        NSString *reason = [NSString stringWithFormat:@"Unable to generate key: %@",
                                                      NSStringFromCCStatus(result)];
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:reason
                                     userInfo:@{ @"errorCode": @(CryptoKitKeyError) }];
    }
    return key;
}

#pragma mark - Helpers

inline NSString *NSStringFromCCStatus(CCStatus status)
{
    switch (status) {
        case kCCSuccess:
            return @"Operation completed normally";
        case kCCParamError:
            return @"Illegal parameter value";
        case kCCBufferTooSmall:
            return @"Insufficent buffer provided for specified operation";
        case kCCMemoryFailure:
            return @"Memory allocation failure";
        case kCCAlignmentError:
            return @"Input size was not aligned properly";
        case kCCDecodeError:
            return @"Input data did not decode or decrypt properly";
        case kCCUnimplemented:
            return @"Function not implemented for the current algorithm";
        default:
            return [NSString stringWithFormat:@"Unknown CCStatus: %d", status];
    }
}

inline void CryptoKitConsumeDataFromInputStream(NSInputStream *inputStream,
                                                NSMutableData *buffer,
                                                void (^callback)(NSInteger bytesRead))
{
    for (;;) {
        NSInteger bytesRead = [inputStream read:[buffer mutableBytes]
                                      maxLength:[buffer length]];
        if (bytesRead < 0) {
            @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                           reason:@"Unable to read data from stream"
                                         userInfo:@{ @"errorCode": @(CryptoKitIOError) }];
        } else if (bytesRead == 0) {
            break;
        } else {
            callback(bytesRead);
        }
    }
}

inline NSError *NSErrorFromException(NSException *exception)
{
    NSCAssert(exception, @"Exception must not be nil");
    NSDictionary *userInfo = [exception userInfo];
    NSNumber *errorCode = userInfo[@"errorCode"];
    NSError *error = [NSError errorWithDomain:CryptoKitErrorDomain
                                         code:[errorCode integerValue]
                                     userInfo:userInfo];
    return error;
}
