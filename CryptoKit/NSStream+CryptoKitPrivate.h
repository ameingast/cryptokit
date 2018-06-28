//
//  NSStream+CryptoKitPrivate.h
//  CryptoKit
//
//  Created by Andreas Meingast on 15/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSStream (CryptoKitPrivate)

+ (void)createBoundInputStream:(NSInputStream **__nullable)inputStream
                  outputStream:(NSOutputStream **__nullable)outputStream
                    bufferSize:(int32_t)bufferSize;

- (id)withOpenStream:(id (^)(void))callback;

@end

NS_ASSUME_NONNULL_END
