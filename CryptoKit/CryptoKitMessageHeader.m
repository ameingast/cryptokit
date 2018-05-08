//
//  CryptoKitMessageHeader.m
//  CryptoKit
//
//  Created by Andreas Meingast on 03/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>

#import "CryptoKitTypes.h"
#import "CryptoKitEngine+Digests.h"
#import "CryptoKitEngine+Keys.h"
#import "CryptoKitMessageHeader.h"
#import "NSInputStream+CryptoKitPrivate.h"
#import "NSOutputStream+CryptoKitPrivate.h"

const uint32_t CryptoKitSerializationVersion = 1;
const uint32_t CryptoKitMagicNumber = 0xCCC31373;
const uint32_t CryptoKitMessageHeaderPaddingSize = 104;
const uint32_t CryptoKitSaltSize = 64;
const uint32_t CryptoKitInitializationVectorBlockSize = kCCBlockSizeAES128;
const CryptoKitDigestType CryptoKitMessageHeaderChecksumDigestType = CryptoKitDigestTypeSHA512;

NS_ASSUME_NONNULL_BEGIN

@interface CryptoKitMessageHeader (Private)

- (NSData *)calculateHeaderChecksum;
- (void)verifyMagicNumber;
- (void)verifyHeaderChecksum;
- (void)verifyVersion;

@end

NS_ASSUME_NONNULL_END

@implementation CryptoKitMessageHeader

@synthesize magicNumber = _magicNumber;
@synthesize version = _version;
@synthesize initializationVector = _initializationVector;
@synthesize salt = _salt;
@synthesize headerChecksum = _headerChecksum;
@synthesize padding = _padding;

- (id)initWithContentsFromInputStream:(NSInputStream *)inputStream
{
    NSAssert(inputStream, @"InputStream must not be nil");
    self = [super init];
    if (!self) {
        return nil;
    }
    _magicNumber = [inputStream blockingReadDataOfLength:sizeof(uint32_t)];
    [self verifyMagicNumber];
    _version = [inputStream blockingReadDataOfLength:sizeof(uint32_t)];
    [self verifyVersion];
    _initializationVector = [inputStream blockingReadDataOfLength:CryptoKitInitializationVectorBlockSize];
    _salt = [inputStream blockingReadDataOfLength:CryptoKitSaltSize];
    _headerChecksum = [inputStream blockingReadDataOfLength:CryptoKitDigestTypeSize(CryptoKitMessageHeaderChecksumDigestType)];
    [self verifyHeaderChecksum];
    _padding = [inputStream blockingReadDataOfLength:CryptoKitMessageHeaderPaddingSize];
    return self;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    CryptoKitEngine *engine = [CryptoKitEngine sharedInstance];
    _magicNumber = [NSData dataWithBytes:&CryptoKitMagicNumber
                                  length:sizeof(uint32_t)];
    _version = [NSData dataWithBytes:&CryptoKitSerializationVersion
                              length:sizeof(uint32_t)];
    _initializationVector = [engine randomBytesWithLength:CryptoKitInitializationVectorBlockSize];
    _salt = [engine randomBytesWithLength:CryptoKitSaltSize];
    _headerChecksum = [self calculateHeaderChecksum];
    _padding = [engine randomBytesWithLength:CryptoKitMessageHeaderPaddingSize];
    return self;
}

- (void)writeToOutputStream:(NSOutputStream *)outputStream
{
    NSAssert(outputStream, @"OutputStream must not be nil");
    [outputStream blockingWriteData:self.magicNumber];
    [outputStream blockingWriteData:self.version];
    [outputStream blockingWriteData:self.initializationVector];
    [outputStream blockingWriteData:self.salt];
    [outputStream blockingWriteData:self.headerChecksum];
    [outputStream blockingWriteData:self.padding];
}

@end

@implementation CryptoKitMessageHeader (Private)

- (NSData *)calculateHeaderChecksum
{
    CryptoKitEngine *engine = [CryptoKitEngine sharedInstance];
    NSUInteger checksumDataLength = [self.initializationVector length] + [self.salt length];
    NSMutableData *initializationVectorAndSalt = [NSMutableData dataWithLength:checksumDataLength];
    NSRange initializationVectorRange = NSMakeRange(0, [self.initializationVector length]);
    NSRange saltRange = NSMakeRange([self.initializationVector length], [self.salt length]);
    [initializationVectorAndSalt replaceBytesInRange:initializationVectorRange
                                           withBytes:[self.initializationVector bytes]];
    [initializationVectorAndSalt replaceBytesInRange:saltRange
                                           withBytes:[self.salt bytes]];
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:initializationVectorAndSalt];
    [inputStream open];
    NSData *digest = [engine calculateDigestInternal:inputStream
                                          digestType:CryptoKitMessageHeaderChecksumDigestType];
    [inputStream close];
    return digest;
}

- (void)verifyMagicNumber
{
    uint32_t magicNumber = 0;
    [self.magicNumber getBytes:&magicNumber
                        length:sizeof(uint32_t)];
    if (magicNumber != CryptoKitMagicNumber) {
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:@"Magic number mismatch"
                                     userInfo:@{ @"errorCode": @(CryptoKitMagicNumberMismatch) }];
    }
}

- (void)verifyHeaderChecksum
{
    NSData *actualChecksum = [self calculateHeaderChecksum];
    if (![self.headerChecksum isEqual:actualChecksum]) {
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:@"Header checksum invalid"
                                     userInfo:@{ @"errorCode": @(CryptoKitMessageHeaderChecksumMismatch) }];
    }
}

- (void)verifyVersion
{
    uint32_t version = 0;
    [self.version getBytes:&version
                    length:sizeof(uint32_t)];
    if (version > CryptoKitSerializationVersion) {
        NSString *reason = [NSString stringWithFormat:@"Binary version incompatible: actual %d (compatible: < %d)",
                                                      version, CryptoKitSerializationVersion];
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:reason
                                     userInfo:@{ @"errorCode": @(CryptoKitVersionMismatch) }];
    }
}

@end
