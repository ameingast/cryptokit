//
//  CryptoKitEngine+Keys.h
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

@import Foundation;

#import "CryptoKitEngine.h"

extern const uint32_t CryptoKitKeyGeneratorRounds;
extern const uint32_t CryptoKitKeySize;

NS_ASSUME_NONNULL_BEGIN

@interface CryptoKitEngine (Keys)

- (NSMutableData *)generateKey:(NSString *)password
                          salt:(NSData *)salt;
- (NSData *)randomBytesWithLength:(size_t)length;

@end

NS_ASSUME_NONNULL_END
