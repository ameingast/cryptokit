//
//  CryptoKitEngine+Digests.m
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "CryptoKitEngine+Digests.h"
#import "CryptoKitErrors.h"
#import "CryptoKitTypes.h"

#import "NSInputStream+CryptoKitPrivate.h"

static const uint32_t CryptoKitDigestStreamBufferSize = 1024;

@implementation CryptoKitEngine (Digests)

- (NSData *)calculateDigestInternal:(NSInputStream *)inputStream
                         digestType:(CryptoKitDigestType)digestType
{
    NSAssert(inputStream, @"InputStream must not be nil");
    NSUInteger digestSize = CryptoKitDigestTypeSize(digestType);
    NSMutableData *digestData = [NSMutableData dataWithLength:digestSize];
    NSMutableData *buffer = [NSMutableData dataWithLength:CryptoKitDigestStreamBufferSize];
    switch (digestType) {
        case CryptoKitDigestTypeError: {
            @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                           reason:@"Invalid digest type"
                                         userInfo:@{ @"errorCode": @(CryptoKitInternalError) }];
        }
        case CryptoKitDigestTypeMD2: {
            CC_MD2_CTX __block ctx = {};
            CC_MD2_Init(&ctx);
            [inputStream consumeDataIntoBuffer:buffer
                                      callback:^(NSUInteger bytesRead) {
                                        CC_MD2_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
                                      }];
            CC_MD2_Final([digestData mutableBytes], &ctx);
            break;
        }
        case CryptoKitDigestTypeMD4: {
            CC_MD4_CTX __block ctx = {};
            CC_MD4_Init(&ctx);
            [inputStream consumeDataIntoBuffer:buffer
                                      callback:^(NSUInteger bytesRead) {
                                        CC_MD4_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
                                      }];
            CC_MD4_Final([digestData mutableBytes], &ctx);
            break;
        }
        case CryptoKitDigestTypeMD5: {
            CC_MD5_CTX __block ctx = {};
            CC_MD5_Init(&ctx);
            [inputStream consumeDataIntoBuffer:buffer
                                      callback:^(NSUInteger bytesRead) {
                                        CC_MD5_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
                                      }];
            CC_MD5_Final([digestData mutableBytes], &ctx);
            break;
        }
        case CryptoKitDigestTypeSHA1: {
            CC_SHA1_CTX __block ctx = {};
            CC_SHA1_Init(&ctx);
            [inputStream consumeDataIntoBuffer:buffer
                                      callback:^(NSUInteger bytesRead) {
                                        CC_SHA1_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
                                      }];
            CC_SHA1_Final([digestData mutableBytes], &ctx);
            break;
        }
        case CryptoKitDigestTypeSHA224: {
            CC_SHA256_CTX __block ctx = {};
            CC_SHA224_Init(&ctx);
            [inputStream consumeDataIntoBuffer:buffer
                                      callback:^(NSUInteger bytesRead) {
                                        CC_SHA224_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
                                      }];
            CC_SHA224_Final([digestData mutableBytes], &ctx);
            break;
        }
        case CryptoKitDigestTypeSHA384: {
            CC_SHA512_CTX __block ctx = {};
            CC_SHA384_Init(&ctx);
            [inputStream consumeDataIntoBuffer:buffer
                                      callback:^(NSUInteger bytesRead) {
                                        CC_SHA384_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
                                      }];
            CC_SHA384_Final([digestData mutableBytes], &ctx);
            break;
        }
        case CryptoKitDigestTypeSHA512: {
            CC_SHA512_CTX __block ctx = {};
            CC_SHA512_Init(&ctx);
            [inputStream consumeDataIntoBuffer:buffer
                                      callback:^(NSUInteger bytesRead) {
                                        CC_SHA512_Update(&ctx, [buffer bytes], (CC_LONG)bytesRead);
                                      }];
            CC_SHA512_Final([digestData mutableBytes], &ctx);
            break;
        }
    }
    return digestData;
}

- (NSString *)digestToHumanReadableRepresentationInternal:(NSData *)data
                                               digestType:(CryptoKitDigestType)digestType
{
    NSAssert(data, @"Data must not be nil");
    const unsigned char *bytes = (const unsigned char *)[data bytes];
    NSUInteger digestLength = CryptoKitDigestTypeSize(digestType);
    NSMutableString *result = [NSMutableString stringWithCapacity:digestLength * 2];
    for (NSUInteger i = 0; i < digestLength; i++) {
        [result appendFormat:@"%02x", bytes[i]];
    }
    return result;
}

@end
