//
//  CryptoKitMessageHeader.h
//  CryptoKit
//
//  Created by Andreas Meingast on 03/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CryptoKit/CryptoKitTypes.h>

NS_ASSUME_NONNULL_BEGIN

extern const uint32_t CryptoKitSerializationVersion;
extern const uint32_t CryptoKitMagicNumber;
extern const uint32_t CryptoKitMessageHeaderPaddingSize;
extern const uint32_t CryptoKitSaltSize;
extern const uint32_t CryptoKitInitializationVectorBlockSize;
extern const CryptoKitDigestType CryptoKitMessageHeaderChecksumDigestType;

@interface CryptoKitMessageHeader : NSObject

@property (nonatomic, readonly) NSData *magicNumber;
@property (nonatomic, readonly) NSData *version;
@property (nonatomic, readonly) NSData *initializationVector;
@property (nonatomic, readonly) NSData *salt;
@property (nonatomic, readonly) NSData *headerChecksum;
@property (nonatomic, readonly) NSData *padding;

- (id)init;
- (id)initWithContentsFromInputStream:(NSInputStream *)inputStream;
- (void)writeToOutputStream:(NSOutputStream *)outputStream;

@end

NS_ASSUME_NONNULL_END
