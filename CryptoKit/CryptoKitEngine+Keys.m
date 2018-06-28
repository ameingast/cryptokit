//
//  CryptoKitEngine+Keys.m
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>

#import "CryptoKitTypes.h"
#import "CryptoKitEngine+Keys.h"

const uint32_t CryptoKitKeyGeneratorRounds = 100000;
const uint32_t CryptoKitKeySize = kCCKeySizeAES256;

@implementation CryptoKitEngine (Keys)

- (NSMutableData *)generateKey:(NSString *)password
                          salt:(NSData *)salt
{
    NSAssert(password, @"Password must not be nil");
    NSAssert(salt, @"Salt must not be nil");
    NSMutableData *key = [NSMutableData dataWithLength:CryptoKitKeySize];
    CCCryptorStatus result = CCKeyDerivationPBKDF(kCCPBKDF2,
                                                  [password UTF8String],
                                                  [password length],
                                                  [salt bytes],
                                                  [salt length],
                                                  kCCPRFHmacAlgSHA512,
                                                  CryptoKitKeyGeneratorRounds,
                                                  [key mutableBytes],
                                                  [key length]);
    if (result != kCCSuccess) {
        NSString *reason = [NSString stringWithFormat:@"Key generation failed: %@",
                                                      NSStringFromCCStatus(result)];
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:reason
                                     userInfo:@{ @"errorCode": @(CryptoKitKeyError) }];
    }
    return key;
}

- (NSData *)randomBytesWithLength:(size_t)length
{
    NSMutableData *data = [NSMutableData dataWithLength:length];
    NSInteger result = SecRandomCopyBytes(kSecRandomDefault, [data length], [data mutableBytes]);
    if (result != 0) {
        NSString *reason = [NSString stringWithFormat:@"Random byte generation failed: %@",
                                                      @(strerror(errno))];
        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                       reason:reason
                                     userInfo:@{ @"errorCode": @(CryptoKitInternalError) }];
    }
    return data;
}

@end
