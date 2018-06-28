//
//  CryptoKitBaseTestCase.h
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

@import CryptoKit;
@import Foundation;
@import XCTest;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const CryptoKitPassword;
extern NSString *const CryptoKitTestsInput;
extern const NSUInteger CryptoKitDataBlobSize;

@interface CryptoKitBaseTestCase : XCTestCase

- (NSData *)dataBlob;
- (void)withInputStream:(NSData *)content
               callback:(void (^)(NSInputStream *inputStream))callback;
- (void)withInMemoryOutputStream:(void (^)(NSOutputStream *outputStream))callback;
- (void)withTemporaryFileURL:(nullable NSData *)content
                    callback:(void (^)(NSURL *url))callback;
- (void)withTemporaryDirectoryURL:(void (^)(NSURL *url))callback;
- (NSUInteger)randomNumberWithLowerBound:(NSUInteger)lowerBound
                           andUpperBound:(NSUInteger)upperBound;

NS_ASSUME_NONNULL_END

@end
