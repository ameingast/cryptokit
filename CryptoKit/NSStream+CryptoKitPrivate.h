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

+ (void)createBoundInputStream:(NSInputStream *_Nonnull *_Nullable)inputStream
                  outputStream:(NSOutputStream *_Nonnull *_Nullable)outputStream
                    bufferSize:(int32_t)bufferSize;

@end

NS_ASSUME_NONNULL_END
