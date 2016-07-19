//
//  NSInputStream+CryptoKitPrivate.h
//  CryptoKit
//
//  Created by Andreas Meingast on 15/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSInputStream (CryptoKitPrivate)

- (void)consumeDataIntoBuffer:(NSMutableData *)buffer
                     callback:(void (^)(NSUInteger bytesRead))callback;
- (NSData *)blockingReadDataOfLength:(NSUInteger)length;

@end

NS_ASSUME_NONNULL_END
