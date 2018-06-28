//
//  CryptoKitEngine+Encryption.h
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import "CryptoKitEngine.h"

extern const int32_t CryptoKitRecryptionBufferSize;

NS_ASSUME_NONNULL_BEGIN

@interface CryptoKitEngine (Encryption)

- (void)encryptStreamInternal:(NSInputStream *)inputStream
                 outputStream:(NSOutputStream *)outputStream
                     password:(NSString *)password;
- (void)decryptStreamInternal:(NSInputStream *)inputStream
                 outputStream:(NSOutputStream *)outputStream
                     password:(NSString *)password;
- (void)recryptStreamInternal:(NSInputStream *)inputStream
                 outputStream:(NSOutputStream *)outputStream
                 withPassword:(NSString *)password
                  newPassword:(NSString *)newPassword;

@end

NS_ASSUME_NONNULL_END
