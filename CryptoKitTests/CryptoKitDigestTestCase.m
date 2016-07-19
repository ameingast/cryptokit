//
//  CryptoKitDigestTestCase.m
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CryptoKit/CryptoKit.h>
#import <CryptoKit/CryptoKitErrors.h>

#import "CryptoKitBaseTestCase.h"

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

@interface CryptoKitDigestTestCase : CryptoKitBaseTestCase

@end

@implementation CryptoKitDigestTestCase

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
    [self withTemporaryFileURL:data callback:^(NSURL *url) {
      NSError *error = nil;
      NSString *MD2Result = [url md2HexHash:&error];
      XCTAssertNil(error);
      XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD2, MD2Result);
    }];
    [self withTemporaryFileURL:data callback:^(NSURL *url) {
      NSError *error = nil;
      NSString *MD4Result = [url md4HexHash:&error];

      XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD4, MD4Result);
    }];
    [self withTemporaryFileURL:data callback:^(NSURL *url) {
      NSError *error = nil;
      NSString *MD5Result = [url md5HexHash:&error];
      XCTAssertNil(error);
      XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD5, MD5Result);
    }];
    [self withTemporaryFileURL:data callback:^(NSURL *url) {
      NSError *error = nil;
      NSString *SHA1Result = [url sha1HexHash:&error];
      XCTAssertNil(error);
      XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA1, SHA1Result);
    }];
    [self withTemporaryFileURL:data callback:^(NSURL *url) {
      NSError *error = nil;
      NSString *SHA224Result = [url sha224HexHash:&error];
      XCTAssertNil(error);
      XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA224, SHA224Result);
    }];
    [self withTemporaryFileURL:data callback:^(NSURL *url) {
      NSError *error = nil;
      NSString *SHA384Result = [url sha384HexHash:&error];
      XCTAssertNil(error);
      XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA384, SHA384Result);
    }];
    [self withTemporaryFileURL:data callback:^(NSURL *url) {
      NSError *error = nil;
      NSString *SHA512Result = [url sha512HexHash:&error];
      XCTAssertNil(error);
      XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA512, SHA512Result);
    }];
}

- (void)testNSStreamDigesting
{
    NSData *data = [CryptoKitTestsInput dataUsingEncoding:NSUTF8StringEncoding];
    [self withInputStream:data
                 callback:^(NSInputStream *inputStream) {
                   NSError *error = nil;
                   NSString *MD2Result = [inputStream md2HexHash:&error];
                   XCTAssertNil(error);
                   XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD2, MD2Result);
                 }];
    [self withInputStream:data
                 callback:^(NSInputStream *inputStream) {
                   NSError *error = nil;
                   NSString *MD4Result = [inputStream md4HexHash:&error];
                   XCTAssertNil(error);
                   XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD4, MD4Result);
                 }];
    [self withInputStream:data
                 callback:^(NSInputStream *inputStream) {
                   NSError *error = nil;
                   NSString *MD5Result = [inputStream md5HexHash:&error];
                   XCTAssertNil(error);
                   XCTAssertEqualObjects(CryptoKitTestsInputExpectedMD5, MD5Result);
                 }];
    [self withInputStream:data
                 callback:^(NSInputStream *inputStream) {
                   NSError *error = nil;
                   NSString *SHA1Result = [inputStream sha1HexHash:&error];
                   XCTAssertNil(error);
                   XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA1, SHA1Result);
                 }];
    [self withInputStream:data
                 callback:^(NSInputStream *inputStream) {
                   NSError *error = nil;
                   NSString *SHA224Result = [inputStream sha224HexHash:&error];
                   XCTAssertNil(error);
                   XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA224, SHA224Result);
                 }];
    [self withInputStream:data
                 callback:^(NSInputStream *inputStream) {
                   NSError *error = nil;
                   NSString *SHA384Result = [inputStream sha384HexHash:&error];
                   XCTAssertNil(error);
                   XCTAssertEqualObjects(CryptoKitTestsInputExpectedSHA384, SHA384Result);
                 }];
    [self withInputStream:data
                 callback:^(NSInputStream *inputStream) {
                   NSError *error = nil;
                   NSString *SHA512Result = [inputStream sha512HexHash:&error];
                   XCTAssertNil(error);
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

@end
