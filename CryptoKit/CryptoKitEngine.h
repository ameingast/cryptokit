//
//  CryptoKitEngine.h
//  CryptoKit
//
//  Created by Andreas Meingast on 09/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

@import Foundation;

#import "CryptoKitTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface CryptoKitEngine : NSObject

+ (CryptoKitEngine *)sharedInstance;

#pragma mark - Digests

- (nullable NSData *)calculateDigest:(NSInputStream *)inputStream
                          digestType:(CryptoKitDigestType)digestType
                               error:(NSError *__nullable *)error;
- (nullable CKDigestBatchResult *)calculateDigests:(NSInputStream *)inputStream
                                             error:(NSError *__nullable *)error;
- (nullable NSString *)digestToHumanReadableRepresentation:(NSData *)data
                                                digestType:(CryptoKitDigestType)digestType
                                                     error:(NSError *__nullable *)error;

#pragma mark - Encryption

- (BOOL)encryptStream:(NSInputStream *)inputStream
         outputStream:(NSOutputStream *)outputStream
             password:(NSString *)password
                error:(NSError *__nullable *)error;
- (BOOL)decryptStream:(NSInputStream *)inputStream
         outputStream:(NSOutputStream *)outputStream
             password:(NSString *)password
                error:(NSError *__nullable *)error;
- (BOOL)recryptInputStream:(NSInputStream *)inputStream
            toOutputStream:(NSOutputStream *)outputStream
                  password:(NSString *)password
               newPassword:(NSString *)newPassword
                     error:(NSError *__nullable *)error;

@end

NS_ASSUME_NONNULL_END
