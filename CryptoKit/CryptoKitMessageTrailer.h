//
//  CryptoKitMessageTrailer.h
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

extern const uint32_t CryptoKitTrailerEncryptionAlgorithm;
extern const uint32_t CryptoKitTrailerEncryptionPadding;

@interface CryptoKitMessageTrailer : NSObject

- (void)encryptPayloadDigestAndWriteToOutputStream:(NSOutputStream *)outputStream
                              initializationVector:(NSData *)initializationVector
                                               key:(NSData *)key
                                    digestChecksum:(NSData *)checksum;
- (void)decryptPayloadDigestAndVerify:(NSData *)encryptedDigest
                 initializationVector:(NSData *)initializationVector
                                  key:(NSData *)key
                       expectedDigest:(NSData *)expectedDigest;

@end

NS_ASSUME_NONNULL_END
