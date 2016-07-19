//
//  CryptoKitEncryptionTestCase.m
//  CryptoKit
//
//  Created by Andreas Meingast on 09/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CryptoKit/CryptoKit.h>
#import <CryptoKit/CryptoKitErrors.h>

#import "CryptoKitBaseTestCase.h"
#import "CryptoKitEngine+Keys.h"

@interface CryptoKitEncryptionTestCase : CryptoKitBaseTestCase

@end

@implementation CryptoKitEncryptionTestCase

#pragma mark - Encryption

- (void)testNSDataEncryption
{
    NSError *encryptionError = nil, *decryptionError = nil;
    NSData *data = [CryptoKitTestsInput dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:&encryptionError];
    XCTAssertNotNil(encryptedData);
    XCTAssertNil(encryptionError);
    NSData *decryptedData = [encryptedData decryptedDataWithPassword:CryptoKitPassword
                                                               error:&decryptionError];
    XCTAssertNotNil(decryptedData);
    XCTAssertNil(decryptionError);
    XCTAssertEqualObjects(data, decryptedData);
}

- (void)testNSURLEncryption
{
    NSData *input = [self dataBlob];
    [self withTemporaryFileURL:input callback:^(NSURL *source) {
      [self withTemporaryFileURL:nil callback:^(NSURL *encrypted) {
        [self withTemporaryFileURL:nil callback:^(NSURL *destination) {
          NSError *encryptionError = nil, *decryptionError = nil;
          BOOL encryptionResult = [source encryptedURLWithPassword:CryptoKitPassword
                                                         targetURL:encrypted
                                                             error:&encryptionError];
          XCTAssertTrue(encryptionResult);
          XCTAssertNil(encryptionError);
          BOOL decryptionResult = [encrypted decryptedURLWithPassword:CryptoKitPassword
                                                            targetURL:destination
                                                                error:&decryptionError];
          NSData *result = [NSData dataWithContentsOfURL:destination];
          XCTAssertTrue(decryptionResult);
          XCTAssertNil(decryptionError);
          XCTAssertEqualObjects(input, result);
        }];
      }];
    }];
}

- (void)testNSStreamEncryption
{
    NSError *encryptionError = nil, *decryptionError = nil;
    NSData *data = [self dataBlob];
    NSInputStream *encryptingInputStream = [NSInputStream inputStreamWithData:data];
    NSOutputStream *encryptedOutputStream = [NSOutputStream outputStreamToMemory];
    BOOL encryptionResult = [NSStream encryptInputStream:encryptingInputStream
                                          toOutputStream:encryptedOutputStream
                                                password:CryptoKitPassword
                                                   error:&encryptionError];
    XCTAssertTrue(encryptionResult);
    XCTAssertNil(encryptionError);
    NSData *encryptedData = [encryptedOutputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    NSInputStream *decryptingInputStream = [NSInputStream inputStreamWithData:encryptedData];
    NSOutputStream *decryptedOutputStream = [NSOutputStream outputStreamToMemory];
    BOOL decryptionResult = [NSStream decryptInputStream:decryptingInputStream
                                          toOutputStream:decryptedOutputStream
                                                password:CryptoKitPassword
                                                   error:&decryptionError];
    XCTAssertTrue(decryptionResult);
    XCTAssertNil(decryptionError);
    NSData *decryptedData = [decryptedOutputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    XCTAssertEqualObjects(data, decryptedData);
}

- (void)testEncryptionWithVaryingSizes
{
    dispatch_group_t group = dispatch_group_create();
    for (NSUInteger i = 1; i < 1024 * 8; i += [self randomNumberWithLowerBound:1
                                                                 andUpperBound:97]) {
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
          @try {
              NSError *encryptionError = nil, *decryptionError = nil;
              NSData *data = [[CryptoKitEngine sharedInstance] randomBytesWithLength:i];
              NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                                error:&encryptionError];
              XCTAssertNotNil(encryptedData);
              XCTAssertNil(encryptionError);
              NSData *decryptedData = [encryptedData decryptedDataWithPassword:CryptoKitPassword
                                                                         error:&decryptionError];
              XCTAssertNotNil(decryptedData);
              XCTAssertEqualObjects(data, decryptedData, @"Payload size: %ld - %@", i, decryptionError);
          } @finally {
              dispatch_group_leave(group);
          }
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

- (void)testNSStreamRecryption
{
    NSData *data = [self dataBlob];
    NSError *encryptionError = nil, *recryptionError, *decryptionError;
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:&encryptionError];
    XCTAssertNotNil(encryptedData);
    XCTAssertNil(encryptionError);
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:encryptedData];
    NSOutputStream *recryptionOutputStream = [NSOutputStream outputStreamToMemory];
    [inputStream open];
    [recryptionOutputStream open];
    BOOL recryptionResult = [inputStream recryptWithPassword:CryptoKitPassword
                                                 newPassword:@"NewPassword"
                                                    toStream:recryptionOutputStream
                                                       error:&recryptionError];
    XCTAssertTrue(recryptionResult);
    XCTAssertNil(recryptionError);
    NSData *recryptedData = [recryptionOutputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    [recryptionOutputStream close];
    [inputStream close];
    NSData *decryptedData = [recryptedData decryptedDataWithPassword:@"NewPassword"
                                                               error:&decryptionError];
    XCTAssertEqualObjects(data, decryptedData);
    XCTAssertNil(decryptionError);
}

- (void)testNSDataRecryption
{
    NSError *encryptionError = nil, *recryptionError = nil, *decryptionError = nil;
    NSData *data = [self dataBlob];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:&encryptionError];
    XCTAssertNotNil(encryptedData);
    XCTAssertNil(encryptionError);
    NSData *recryptedData = [encryptedData recryptDataWithPassword:CryptoKitPassword
                                                       newPassword:@"NewPassword"
                                                             error:&recryptionError];
    XCTAssertNotNil(recryptedData);
    XCTAssertNil(recryptionError);
    NSData *decryptedData = [recryptedData decryptedDataWithPassword:@"NewPassword"
                                                               error:&decryptionError];
    XCTAssertEqualObjects(data, decryptedData);
    XCTAssertNil(decryptionError);
}

- (void)testNSURLRecryption
{
    NSData *data = [self dataBlob];
    [self withTemporaryFileURL:data callback:^(NSURL *plainURL) {
      [self withTemporaryFileURL:nil callback:^(NSURL *encryptedURL) {
        NSError *encryptionError = nil;
        BOOL encryptionResult = [plainURL encryptedURLWithPassword:CryptoKitPassword
                                                         targetURL:encryptedURL
                                                             error:&encryptionError];
        XCTAssertTrue(encryptionResult);
        XCTAssertNil(encryptionError);
        [self withTemporaryFileURL:nil callback:^(NSURL *recryptedURL) {
          NSError *recryptionError = nil;
          BOOL recryptionResult = [encryptedURL recryptedURLWithPassword:CryptoKitPassword
                                                             newPassword:@"NewPassword"
                                                               targetURL:recryptedURL
                                                                   error:&recryptionError];
          XCTAssertTrue(recryptionResult);
          XCTAssertNil(recryptionError);
          [self withTemporaryFileURL:nil callback:^(NSURL *decryptedURL) {
            NSError *decryptionError = nil;
            BOOL decryptionResult = [recryptedURL decryptedURLWithPassword:@"NewPassword"
                                                                 targetURL:decryptedURL
                                                                     error:&decryptionError];
            XCTAssertTrue(decryptionResult);
            XCTAssertNil(decryptionError);
            NSData *decryptedData = [NSData dataWithContentsOfURL:decryptedURL];
            XCTAssertEqualObjects(data, decryptedData);
          }];
        }];
      }];
    }];
}

#pragma mark - Compatibility

- (void)testFileCompatibility
{
    NSError *error = nil;
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *encryptedDataURL = [bundle URLForResource:@"EncryptedFileV1"
                                       withExtension:@"bin"];
    NSData *encryptedData = [NSData dataWithContentsOfURL:encryptedDataURL];
    NSData *decryptedData = [encryptedData decryptedDataWithPassword:CryptoKitPassword
                                                               error:&error];
    XCTAssertNotNil(decryptedData);
    XCTAssertNil(error);
    NSString *decryptedString = [[NSString alloc] initWithData:decryptedData
                                                      encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(CryptoKitTestsInput, decryptedString);
}

#pragma mark - Error Cases

- (void)testEncryptWithClosedInputStream
{
    NSError *error = nil;
    NSData *data = [self dataBlob];
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:data];
    NSOutputStream *outputStream = [NSOutputStream outputStreamToMemory];
    [outputStream open];
    BOOL encryptionResult = [inputStream encryptWithPassword:CryptoKitPassword
                                                    toStream:outputStream
                                                       error:&error];
    [outputStream close];
    XCTAssertFalse(encryptionResult);
    XCTAssertEqual(error.code, CryptoKitIOError);
}

- (void)testEncryptionWithClosedOutputStream
{
    NSError *error = nil;
    NSData *data = [self dataBlob];
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:data];
    NSOutputStream *outputStream = [NSOutputStream outputStreamToMemory];
    [inputStream open];
    BOOL encryptionResult = [inputStream encryptWithPassword:CryptoKitPassword
                                                    toStream:outputStream
                                                       error:&error];
    [inputStream close];
    XCTAssertFalse(encryptionResult);
    XCTAssertEqual(error.code, CryptoKitIOError);
}

- (void)testDecryptionWithBadMagicNumber
{
    NSError *error = nil;
    NSData *data = [self dataBlob];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:&error];
    XCTAssertNotNil(encryptedData);
    XCTAssertNil(error);
    NSData *manipulatedEncryptedData = [self replaceMagicNumberInEncryptedData:encryptedData
                                                                     withValue:123456789];
    NSData *decryptedData = [manipulatedEncryptedData decryptedDataWithPassword:CryptoKitPassword
                                                                          error:&error];
    XCTAssertNil(decryptedData);
    XCTAssertEqual(error.code, CryptoKitMagicNumberMismatch);
}

- (void)testDecryptionWithIncompatibleVersion
{
    NSError *error = nil;
    NSData *data = [self dataBlob];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:&error];
    XCTAssertNotNil(encryptedData);
    XCTAssertNil(error);
    NSData *manipulatedEncryptedData = [self replaceSerializationVersionInEncryptedData:encryptedData
                                                                              withValue:999];
    NSData *decryptedData = [manipulatedEncryptedData decryptedDataWithPassword:CryptoKitPassword
                                                                          error:&error];
    XCTAssertNil(decryptedData);
    XCTAssertEqual(error.code, CryptoKitVersionMismatch);
}

- (void)testDecryptionWithBadInitializationVector
{
    NSError *encryptionError = nil, *decryptionError = nil;
    NSData *data = [self dataBlob];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:&encryptionError];
    XCTAssertNotNil(encryptedData);
    XCTAssertNil(encryptionError);
    NSData *manipulatedEncryptedData = [self replaceInitializationVectorInEncryptedData:encryptedData
                                                                              withValue:123456789];
    NSData *decryptedData = [manipulatedEncryptedData decryptedDataWithPassword:CryptoKitPassword
                                                                          error:&decryptionError];
    XCTAssertNil(decryptedData);
    XCTAssertEqual(decryptionError.code, CryptoKitMessageHeaderChecksumMismatch);
}

- (void)testDecryptionWithBadSalt
{
    NSError *encryptionError = nil, *decryptionError = nil;
    NSData *data = [self dataBlob];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:&encryptionError];
    XCTAssertNotNil(encryptedData);
    XCTAssertNil(encryptionError);
    NSData *manipulatedEncryptedData = [self replaceSaltInEncryptedData:encryptedData
                                                              withValue:123456789];
    NSData *decryptedData = [manipulatedEncryptedData decryptedDataWithPassword:CryptoKitPassword
                                                                          error:&decryptionError];
    XCTAssertNil(decryptedData);
    XCTAssertEqual(decryptionError.code, CryptoKitMessageHeaderChecksumMismatch);
}

- (void)testDecryptionWithBadHeaderChecksum
{
    NSError *encryptionError = nil, *decryptionError = nil;
    NSData *data = [self dataBlob];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:&encryptionError];
    XCTAssertNotNil(encryptedData);
    XCTAssertNil(encryptionError);
    NSData *manipulatedEncryptedData = [self replaceChecksumInEncryptedData:encryptedData
                                                                  withValue:123456789];
    NSData *decryptedData = [manipulatedEncryptedData decryptedDataWithPassword:CryptoKitPassword
                                                                          error:&decryptionError];
    XCTAssertNil(decryptedData);
    XCTAssertEqual(decryptionError.code, CryptoKitMessageHeaderChecksumMismatch);
}

- (void)testDecryptionWithBadPassword
{
    NSError *encryptionError = nil, *decryptionError = nil;
    NSData *data = [self dataBlob];
    NSInputStream *encryptingInputStream = [NSInputStream inputStreamWithData:data];
    NSOutputStream *encryptedOutputStream = [NSOutputStream outputStreamToMemory];
    BOOL encryptionResult = [NSStream encryptInputStream:encryptingInputStream
                                          toOutputStream:encryptedOutputStream
                                                password:CryptoKitPassword
                                                   error:&encryptionError];
    XCTAssertTrue(encryptionResult);
    XCTAssertNil(encryptionError);
    NSData *encryptedData = [encryptedOutputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    NSInputStream *decryptingInputStream = [NSInputStream inputStreamWithData:encryptedData];
    NSOutputStream *decryptedOutputStream = [NSOutputStream outputStreamToMemory];
    BOOL decryptionResult = [NSStream decryptInputStream:decryptingInputStream
                                          toOutputStream:decryptedOutputStream
                                                password:@"Wrong password"
                                                   error:&decryptionError];
    XCTAssertFalse(decryptionResult);
    XCTAssertEqual(decryptionError.code, CryptoKitPayloadChecksumMismatch);
}

- (void)testDecryptionWithTruncatedBody
{
    NSError *encryptionError = nil, *decryptionError = nil;
    NSData *data = [self dataBlob];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:&encryptionError];
    XCTAssertNotNil(encryptedData);
    XCTAssertNil(encryptionError);
    NSData *truncatedData = [encryptedData subdataWithRange:NSMakeRange(0, [encryptedData length] / 2)];
    NSData *decryptedData = [truncatedData decryptedDataWithPassword:CryptoKitPassword
                                                               error:&decryptionError];
    XCTAssertNil(decryptedData);
    XCTAssertEqual(decryptionError.code, CryptoKitPayloadChecksumMismatch);
}

- (void)testDecryptionWithTruncatedTrailer
{
    NSError *encryptionError = nil, *decryptionError = nil;
    NSData *data = [self dataBlob];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:&encryptionError];
    XCTAssertNotNil(encryptedData);
    XCTAssertNil(encryptionError);
    NSData *truncatedData = [encryptedData subdataWithRange:NSMakeRange(0, [encryptedData length] - 32)];
    NSData *decryptedData = [truncatedData decryptedDataWithPassword:CryptoKitPassword
                                                               error:&decryptionError];
    XCTAssertNil(decryptedData);
    XCTAssertEqual(decryptionError.code, CryptoKitPayloadChecksumMismatch);
}

- (void)testDecryptionWithEmptyPayload
{
    NSError *encryptionError = nil, *decryptionError = nil;
    NSData *data = [self dataBlob];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:&encryptionError];
    XCTAssertNotNil(encryptedData);
    XCTAssertNil(encryptionError);
    NSData *truncatedData = [encryptedData subdataWithRange:NSMakeRange(0, 256)];
    NSData *decryptedData = [truncatedData decryptedDataWithPassword:CryptoKitPassword
                                                               error:&decryptionError];
    XCTAssertNil(decryptedData);
    XCTAssertEqual(decryptionError.code, CryptoKitPayloadChecksumMismatch);
}

- (void)testDecryptionWithBadTrailer
{
    NSError *encryptionError = nil, *decryptionError = nil;
    NSData *data = [self dataBlob];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:&encryptionError];
    XCTAssertNotNil(encryptedData);
    XCTAssertNil(encryptionError);
    NSData *manipulatedEncryptedData = [self replaceTrailerChecksumInEncryptedData:encryptedData
                                                                         withValue:123456789];
    NSData *decryptedData = [manipulatedEncryptedData decryptedDataWithPassword:CryptoKitPassword
                                                                          error:&decryptionError];
    XCTAssertNil(decryptedData);
    XCTAssertEqual(decryptionError.code, CryptoKitPayloadChecksumMismatch);
}

#pragma mark - Performance

- (void)testPerformanceOfNSDataEncryption
{
    NSData *data = [self dataBlob];
    [self measureBlock:^{
      NSError *error = nil;
      NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                        error:&error];
      XCTAssertNotNil(encryptedData);
      XCTAssertNil(error);
    }];
}

- (void)testPerformanceOfNSDataDecryption
{
    NSData *data = [self dataBlob];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:nil];
    [self measureBlock:^{
      NSError *error = nil;
      NSData *decryptedData = [encryptedData decryptedDataWithPassword:CryptoKitPassword
                                                                 error:&error];
      XCTAssertNotNil(decryptedData);
      XCTAssertNil(error);
    }];
}

- (void)testPerformanceOfNSStreamEncryption
{
    NSData *data = [self dataBlob];
    [self measureBlock:^{
      [self withInputStream:data
                   callback:^(NSInputStream *encryptingInputStream) {
                     [self withInMemoryOutputStream:^(NSOutputStream *encryptedOutputStream) {
                       NSError *error = nil;
                       BOOL result = [encryptingInputStream encryptWithPassword:CryptoKitPassword
                                                                       toStream:encryptedOutputStream
                                                                          error:&error];
                       XCTAssertTrue(result);
                       XCTAssertNil(error);
                     }];
                   }];
    }];
}

#pragma mark - Integration

- (void)testEncryptionIntegrity
{
    NSError *encryptionError = nil, *decryptionError = nil;
    NSData *plainData = [self dataBlob];
    NSString *plainDataHash = [plainData sha512HexHash];
    NSData *encryptedData = [plainData encryptedDataWithPassword:CryptoKitPassword
                                                           error:&encryptionError];
    XCTAssertNotNil(encryptedData);
    XCTAssertNil(encryptionError);
    NSData *decryptedData = [encryptedData decryptedDataWithPassword:CryptoKitPassword
                                                               error:&decryptionError];
    XCTAssertNotNil(decryptedData);
    XCTAssertNil(decryptionError);
    NSString *decryptedDataHash = [decryptedData sha512HexHash];
    XCTAssertEqualObjects(plainDataHash, decryptedDataHash);
}

#pragma mark - Helpers

- (NSData *)replaceMagicNumberInEncryptedData:(NSData *)data
                                    withValue:(NSUInteger)magicNumber
{
    NSMutableData *mutableEncryptedData = [NSMutableData dataWithData:data];
    [mutableEncryptedData replaceBytesInRange:NSMakeRange(0, 4)
                                    withBytes:&magicNumber];
    return mutableEncryptedData;
}

- (NSData *)replaceSerializationVersionInEncryptedData:(NSData *)data
                                             withValue:(NSUInteger)version
{
    NSMutableData *mutableEncryptedData = [NSMutableData dataWithData:data];
    [mutableEncryptedData replaceBytesInRange:NSMakeRange(4, 4)
                                    withBytes:&version];
    return mutableEncryptedData;
}

- (NSData *)replaceInitializationVectorInEncryptedData:(NSData *)data
                                             withValue:(NSUInteger)initializationVector
{
    NSMutableData *mutableEncryptedData = [NSMutableData dataWithData:data];
    [mutableEncryptedData replaceBytesInRange:NSMakeRange(8, 16)
                                    withBytes:&initializationVector];
    return mutableEncryptedData;
}

- (NSData *)replaceSaltInEncryptedData:(NSData *)data
                             withValue:(NSUInteger)salt
{
    NSMutableData *mutableEncryptedData = [NSMutableData dataWithData:data];
    [mutableEncryptedData replaceBytesInRange:NSMakeRange(24, 64)
                                    withBytes:&salt];
    return mutableEncryptedData;
}

- (NSData *)replaceChecksumInEncryptedData:(NSData *)data
                                 withValue:(NSUInteger)checksum
{
    NSMutableData *mutableEncryptedData = [NSMutableData dataWithData:data];
    [mutableEncryptedData replaceBytesInRange:NSMakeRange(88, 64)
                                    withBytes:&checksum];
    return mutableEncryptedData;
}

- (NSData *)replaceTrailerChecksumInEncryptedData:(NSData *)data
                                        withValue:(NSUInteger)value
{
    NSMutableData *mutableEncryptedData = [NSMutableData dataWithData:data];
    [mutableEncryptedData replaceBytesInRange:NSMakeRange([data length] - 80, 80)
                                    withBytes:&value];
    return mutableEncryptedData;
}

@end
