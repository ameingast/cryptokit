//
//  CryptoKitTests.m
//  CryptoKit
//
//  Created by Andreas Meingast on 09/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CryptoKit/CryptoKit.h>
#import <XCTest/XCTest.h>

static const NSUInteger CryptoKitDataBlobSize = 1024 * 1024 * 100;
static NSString *const CryptoKitPassword = @"123456789";
static NSString *const CryptoKitTestsInput = @"0123456701234567012345670123456701234567012345670123456701234567";
static NSString *const CryptoKitTestsInputExpectedMD2 = @"b397b0941b13002609e2c6e1e57c5749";
static NSString *const CryptoKitTestsInputExpectedMD4 = @"8e0159d48758bcd875e9a0bef42d3d92";
static NSString *const CryptoKitTestsInputExpectedMD5 = @"520620de89e220f9b5850cc97cbff46c";
static NSString *const CryptoKitTestsInputExpectedSHA1 = @"e0c094e867ef46c350ef54a7f59dd60bed92ae83";
static NSString *const CryptoKitTestsInputExpectedSHA224 = @"1152a558c1dbcd023222e3472f2b9a2bdf8984e5d82153e6b126a201";
static NSString *const CryptoKitTestsInputExpectedSHA384 = @"72f5893331c249312d3c2b7a9709a7b96908b7769179dd9824ed5786"
                                                            "69fcc1f1c2de02c03b3d35a467aa0b472c1bb3d1";
static NSString *const CryptoKitTestsInputExpectedSHA512 = @"846e0ef73436438a4acb0ba7078cfe381f10a0f5edebcb985b379008"
                                                            "6ef5e7ac5992ac9c23c77761c764bb3b1c25702d06b99955eb197d45b"
                                                            "82fb3d124699d78";

@interface CryptoKitTests : XCTestCase

NS_ASSUME_NONNULL_BEGIN

- (NSData *)dataBlob;
- (void)withTemporaryFileURL:(nullable NSData *)content
                    callback:(void (^)(NSURL *url))callback;
- (void)withInputStream:(NSData *)content
               callback:(void (^)(NSInputStream *inputStream))callback;
- (void)withInMemoryOutputStream:(void (^)(NSOutputStream *outputStream))callback;

NS_ASSUME_NONNULL_END

@end

@implementation CryptoKitTests

#pragma mark - Digests

- (void)testNSStringDigesting
{
    NSString *MD2Result = [CryptoKitTestsInput md2HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD2, MD2Result);
    NSString *MD4Result = [CryptoKitTestsInput md4HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD4, MD4Result);
    NSString *MD5Result = [CryptoKitTestsInput md5HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD5, MD5Result);
    NSString *SHA1Result = [CryptoKitTestsInput sha1HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA1, SHA1Result);
    NSString *SHA224Result = [CryptoKitTestsInput sha224HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA224, SHA224Result);
    NSString *SHA384Result = [CryptoKitTestsInput sha384HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA384, SHA384Result);
    NSString *SHA512Result = [CryptoKitTestsInput sha512HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA512, SHA512Result);
}

- (void)testNSDataDigesting
{

    NSData *data = [CryptoKitTestsInput dataUsingEncoding:NSUTF8StringEncoding];
    NSString *MD2Result = [data md2HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD2, MD2Result);
    NSString *MD4Result = [data md4HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD4, MD4Result);
    NSString *MD5Result = [data md5HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD5, MD5Result);
    NSString *SHA1Result = [data sha1HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA1, SHA1Result);
    NSString *SHA224Result = [data sha224HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA224, SHA224Result);
    NSString *SHA384Result = [data sha384HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA384, SHA384Result);
    NSString *SHA512Result = [data sha512HexHash];
    XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA512, SHA512Result);
}

- (void)testNSURLDigesting
{
    NSData *data = [CryptoKitTestsInput dataUsingEncoding:NSUTF8StringEncoding];
    [self withTemporaryFileURL:data callback:^(NSURL *_Nonnull url) {
      NSString *MD2Result = [url md2HexHash:nil];
      XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD2, MD2Result);
      NSString *MD4Result = [url md4HexHash:nil];
      XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD4, MD4Result);
      NSString *MD5Result = [url md5HexHash:nil];
      XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD5, MD5Result);
      NSString *SHA1Result = [url sha1HexHash:nil];
      XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA1, SHA1Result);
      NSString *SHA224Result = [url sha224HexHash:nil];
      XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA224, SHA224Result);
      NSString *SHA384Result = [url sha384HexHash:nil];
      XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA384, SHA384Result);
      NSString *SHA512Result = [url sha512HexHash:nil];
      XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA512, SHA512Result);
    }];
}

- (void)testNSStreamDigesting
{
    NSData *data = [CryptoKitTestsInput dataUsingEncoding:NSUTF8StringEncoding];
    [self withInputStream:data
                 callback:^(NSInputStream *_Nonnull inputStream) {
                   NSString *MD2Result = [inputStream md2HexHash:nil];
                   XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD2, MD2Result);
                 }];
    [self withInputStream:data
                 callback:^(NSInputStream *_Nonnull inputStream) {
                   NSString *MD4Result = [inputStream md4HexHash:nil];
                   XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD4, MD4Result);
                 }];
    [self withInputStream:data
                 callback:^(NSInputStream *_Nonnull inputStream) {
                   NSString *MD5Result = [inputStream md5HexHash:nil];
                   XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD5, MD5Result);
                 }];
    [self withInputStream:data
                 callback:^(NSInputStream *_Nonnull inputStream) {
                   NSString *SHA1Result = [inputStream sha1HexHash:nil];
                   XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA1, SHA1Result);
                 }];
    [self withInputStream:data
                 callback:^(NSInputStream *_Nonnull inputStream) {
                   NSString *SHA224Result = [inputStream sha224HexHash:nil];
                   XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA224, SHA224Result);
                 }];
    [self withInputStream:data
                 callback:^(NSInputStream *_Nonnull inputStream) {
                   NSString *SHA384Result = [inputStream sha384HexHash:nil];
                   XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA384, SHA384Result);
                 }];
    [self withInputStream:data
                 callback:^(NSInputStream *_Nonnull inputStream) {
                   NSString *SHA512Result = [inputStream sha512HexHash:nil];
                   XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA512, SHA512Result);
                 }];
}

- (void)testPerformanceOfNSDataDigesting
{
    NSData *data = [self dataBlob];
    [self measureBlock:^{
      [data md5Hash];
    }];
}

#pragma mark - Encryption

- (void)testNSDataEncryption
{
    NSData *data = [CryptoKitTestsInput dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:nil];
    NSData *decryptedData = [encryptedData decryptedDataWithPassword:CryptoKitPassword
                                                               error:nil];
    XCTAssertEqualObjects(data, decryptedData);
}

- (void)testNSURLEncryption
{
    NSData *input = [CryptoKitTestsInput dataUsingEncoding:NSUTF8StringEncoding];
    [self withTemporaryFileURL:input callback:^(NSURL *_Nonnull source) {
      [self withTemporaryFileURL:nil callback:^(NSURL *_Nonnull encrypted) {
        [self withTemporaryFileURL:nil callback:^(NSURL *_Nonnull destination) {
          [source encryptedURLWithPassword:CryptoKitPassword
                                 targetURL:encrypted
                                     error:nil];
          [encrypted decryptedURLWithPassword:CryptoKitPassword
                                    targetURL:destination
                                        error:nil];
          NSData *result = [NSData dataWithContentsOfURL:destination];
          XCTAssertEqualObjects(input, result);
        }];
      }];
    }];
}

- (void)testNSStreamEncryption
{
    NSData *data = [self dataBlob];
    NSInputStream *encryptingInputStream = [NSInputStream inputStreamWithData:data];
    NSOutputStream *encryptedOutputStream = [NSOutputStream outputStreamToMemory];
    [NSStream encryptInputStream:encryptingInputStream
                  toOutputStream:encryptedOutputStream
                        password:CryptoKitPassword
                           error:nil];
    NSData *encryptedData = [encryptedOutputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    NSInputStream *decryptingInputStream = [NSInputStream inputStreamWithData:encryptedData];
    NSOutputStream *decryptedOutputStream = [NSOutputStream outputStreamToMemory];
    [NSStream decryptInputStream:decryptingInputStream
                  toOutputStream:decryptedOutputStream
                        password:CryptoKitPassword
                           error:nil];
    NSData *decryptedData = [decryptedOutputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    XCTAssertEqualObjects(data, decryptedData);
}

- (void)testPerformanceOfNSDataEncryption
{
    NSData *data = [self dataBlob];
    [self measureBlock:^{
      [data encryptedDataWithPassword:CryptoKitPassword
                                error:nil];
    }];
}

- (void)testPerformanceOfNSDataDecryption
{
    NSData *data = [self dataBlob];
    NSData *encryptedData = [data encryptedDataWithPassword:CryptoKitPassword
                                                      error:nil];
    [self measureBlock:^{
      [encryptedData decryptedDataWithPassword:CryptoKitPassword
                                         error:nil];
    }];
}

- (void)testPerformanceOfNSStreamEncryption
{
    NSData *data = [self dataBlob];
    [self measureBlock:^{
      [self withInputStream:data
                   callback:^(NSInputStream *_Nonnull encryptingInputStream) {
                     [self withInMemoryOutputStream:^(NSOutputStream *_Nonnull encryptedOutputStream) {
                       [encryptingInputStream encryptWithPassword:CryptoKitPassword
                                                         toStream:encryptedOutputStream
                                                            error:nil];
                     }];
                   }];
    }];
}

#pragma mark - Integration

- (void)testEncryptionIntegrity
{
    NSData *plainData = [self dataBlob];
    NSString *plainDataHash = [plainData sha512HexHash];
    NSData *encryptedData = [plainData encryptedDataWithPassword:CryptoKitPassword
                                                           error:nil];
    NSData *decryptedData = [encryptedData decryptedDataWithPassword:CryptoKitPassword
                                                               error:nil];
    NSString *decryptedDataHash = [decryptedData sha512HexHash];
    XCTAssertEqualObjects(plainDataHash, decryptedDataHash);
}

#pragma mark - Helpers

- (void)withTemporaryFileURL:(nullable NSData *)content
                    callback:(void (^)(NSURL *url))callback
{
    NSURL *url = nil;
    @try {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:uuid];
        url = [NSURL fileURLWithPath:tmpPath];
        [content writeToURL:url
                 atomically:YES];
        callback(url);
    } @finally {
        if (url) {
            [[NSFileManager defaultManager] removeItemAtURL:url
                                                      error:nil];
        }
    }
}

- (void)withInputStream:(NSData *)content
               callback:(void (^)(NSInputStream *inputStream))callback
{
    NSInputStream *inputStream = nil;
    @try {
        inputStream = [NSInputStream inputStreamWithData:content];
        [inputStream open];
        callback(inputStream);
    } @finally {
        if ([inputStream streamStatus] != NSStreamStatusNotOpen) {
            [inputStream close];
        }
    }
}

- (void)withInMemoryOutputStream:(void (^)(NSOutputStream *outputStream))callback;
{
    NSOutputStream *outputStream = nil;
    @try {
        outputStream = [NSOutputStream outputStreamToMemory];
        [outputStream open];
        callback(outputStream);
    } @finally {
        if ([outputStream streamStatus] != NSStreamStatusNotOpen) {
            [outputStream close];
        }
    }
}

- (NSData *)dataBlob
{
    NSData *result = [NSMutableData dataWithLength:CryptoKitDataBlobSize];
    return result;
}

@end
