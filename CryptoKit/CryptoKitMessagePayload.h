//
//  CryptoKitMessagePayload.h
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

extern const uint32_t CryptoKitPayloadEncryptionStreamBufferSize;
extern const uint32_t CryptoKitPayloadEncryptionAlgorithm;
extern const uint32_t CryptoKitPayloadEncryptionPadding;

@interface CryptoKitMessagePayload : NSObject

@property (nonatomic) NSData *payloadDigest;

- (void)encryptDataFromInputStream:(NSInputStream *)inputStream
                      outputStream:(NSOutputStream *)outputStream
          withInitializationVector:(NSData *)initializationVector
                           withKey:(NSData *)key;
- (NSData *)decryptDataFromInputStream:(NSInputStream *)inputStream
                          outputStream:(NSOutputStream *)outputStream
              withInitializationVector:(NSData *)initializationVector
                               withKey:(NSData *)key;

@end

NS_ASSUME_NONNULL_END
