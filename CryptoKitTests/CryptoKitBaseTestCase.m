//
//  CryptoKitBaseTestCase.m
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import "CryptoKitBaseTestCase.h"
#import "CryptoKitEngine+Keys.h"

NSString *const CryptoKitPassword = @"123456789";
NSString *const CryptoKitTestsInput = @"0123456701234567012345670123456701234567012345670123456701234567";
const NSUInteger CryptoKitDataBlobSize = 1024 * 256 + 137;

@implementation CryptoKitBaseTestCase

- (NSData *)dataBlob
{
    NSData *randomBytes = [[CryptoKitEngine sharedInstance] randomBytesWithLength:CryptoKitDataBlobSize];
    return randomBytes;
}

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
            NSError *error;
            BOOL removeResult = [[NSFileManager defaultManager] removeItemAtURL:url
                                                                          error:&error];
            if (!removeResult) {
                XCTFail(@"Unable to clean up temporary file at: %@ - %@", url, error);
            }
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
        if (inputStream && [inputStream streamStatus] != NSStreamStatusNotOpen) {
            [inputStream close];
        }
    }
}

- (void)withInMemoryOutputStream:(void (^)(NSOutputStream *outputStream))callback
{
    NSOutputStream *outputStream = nil;
    @try {
        outputStream = [NSOutputStream outputStreamToMemory];
        [outputStream open];
        callback(outputStream);
    } @finally {
        if (outputStream && [outputStream streamStatus] != NSStreamStatusNotOpen) {
            [outputStream close];
        }
    }
}

- (NSUInteger)randomNumberWithLowerBound:(NSUInteger)lowerBound
                           andUpperBound:(NSUInteger)upperBound
{
    NSUInteger value = lowerBound + arc4random() % (upperBound - lowerBound);
    return value;
}

@end
