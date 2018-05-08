//
//  CryptoKitEngine+Digests.m
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "CryptoKitEngine+Digests.h"
#import "CryptoKitTypes.h"

#import "NSInputStream+CryptoKitPrivate.h"

static const uint32_t CryptoKitDigestStreamBufferSize = 1024;

@implementation CryptoKitEngine (Digests)

- (NSData *)calculateDigestInternal:(NSInputStream *)inputStream
                         digestType:(CryptoKitDigestType)digestType
{
    NSAssert(inputStream, @"InputStream must not be nil");
    NSMutableData *digestData = [NSMutableData dataWithLength:CryptoKitDigestTypeSize(digestType)];
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

- (CKDigestBatchResult *)calculateDigestsInternal:(NSInputStream *)inputStream
{
    NSAssert(inputStream, @"InputStream must not be nil");
    CC_MD2_CTX __block md2Ctx = {};
    CC_MD4_CTX __block md4Ctx = {};
    CC_MD5_CTX __block md5Ctx = {};
    CC_SHA1_CTX __block sha1Ctx = {};
    CC_SHA256_CTX __block sha224Ctx = {};
    CC_SHA512_CTX __block sha384Ctx = {};
    CC_SHA512_CTX __block sha512Ctx = {};
    NSMutableData *buffer = [NSMutableData dataWithLength:CryptoKitDigestStreamBufferSize];
    NSMutableData *md2DigestData = [NSMutableData dataWithLength:CryptoKitDigestTypeSize(CryptoKitDigestTypeMD2)];
    NSMutableData *md4DigestData = [NSMutableData dataWithLength:CryptoKitDigestTypeSize(CryptoKitDigestTypeMD4)];
    NSMutableData *md5DigestData = [NSMutableData dataWithLength:CryptoKitDigestTypeSize(CryptoKitDigestTypeMD5)];
    NSMutableData *sha1DigestData = [NSMutableData dataWithLength:CryptoKitDigestTypeSize(CryptoKitDigestTypeSHA1)];
    NSMutableData *sha224DigestData = [NSMutableData dataWithLength:CryptoKitDigestTypeSize(CryptoKitDigestTypeSHA224)];
    NSMutableData *sha384DigestData = [NSMutableData dataWithLength:CryptoKitDigestTypeSize(CryptoKitDigestTypeSHA384)];
    NSMutableData *sha512DigestData = [NSMutableData dataWithLength:CryptoKitDigestTypeSize(CryptoKitDigestTypeSHA512)];
    CC_MD2_Init(&md2Ctx);
    CC_MD4_Init(&md4Ctx);
    CC_MD5_Init(&md5Ctx);
    CC_SHA1_Init(&sha1Ctx);
    CC_SHA224_Init(&sha224Ctx);
    CC_SHA384_Init(&sha384Ctx);
    CC_SHA512_Init(&sha512Ctx);
    [inputStream consumeDataIntoBuffer:buffer
                              callback:^(NSUInteger bytesRead) {
                                  const void *bytes = [buffer bytes];
                                  CC_MD2_Update(&md2Ctx, bytes, (CC_LONG)bytesRead);
                                  CC_MD4_Update(&md4Ctx, bytes, (CC_LONG)bytesRead);
                                  CC_MD5_Update(&md5Ctx, bytes, (CC_LONG)bytesRead);
                                  CC_SHA1_Update(&sha1Ctx, bytes, (CC_LONG)bytesRead);
                                  CC_SHA224_Update(&sha224Ctx, bytes, (CC_LONG)bytesRead);
                                  CC_SHA384_Update(&sha384Ctx, bytes, (CC_LONG)bytesRead);
                                  CC_SHA512_Update(&sha512Ctx, bytes, (CC_LONG)bytesRead);
                              }];
    CC_MD2_Final([md2DigestData mutableBytes], &md2Ctx);
    CC_MD4_Final([md4DigestData mutableBytes], &md4Ctx);
    CC_MD5_Final([md5DigestData mutableBytes], &md5Ctx);
    CC_SHA1_Final([sha1DigestData mutableBytes], &sha1Ctx);
    CC_SHA224_Final([sha224DigestData mutableBytes], &sha224Ctx);
    CC_SHA384_Final([sha384DigestData mutableBytes], &sha384Ctx);
    CC_SHA512_Final([sha512DigestData mutableBytes], &sha512Ctx);
    NSString *md2HextDigest = [self digestToHumanReadableRepresentationInternal:md2DigestData
                                                                     digestType:CryptoKitDigestTypeMD2];
    NSString *md4HextDigest = [self digestToHumanReadableRepresentationInternal:md4DigestData
                                                                     digestType:CryptoKitDigestTypeMD4];
    NSString *md5HextDigest = [self digestToHumanReadableRepresentationInternal:md5DigestData
                                                                     digestType:CryptoKitDigestTypeMD5];
    NSString *sha1HextDigest = [self digestToHumanReadableRepresentationInternal:sha1DigestData
                                                                      digestType:CryptoKitDigestTypeSHA1];
    NSString *sha224HextDigest = [self digestToHumanReadableRepresentationInternal:sha224DigestData
                                                                        digestType:CryptoKitDigestTypeSHA224];
    NSString *sha384HextDigest = [self digestToHumanReadableRepresentationInternal:sha384DigestData
                                                                        digestType:CryptoKitDigestTypeSHA384];
    NSString *sha512HextDigest = [self digestToHumanReadableRepresentationInternal:sha512DigestData
                                                                        digestType:CryptoKitDigestTypeSHA512];
    return [[CKDigestBatchResult alloc] initWithMd2Digest:md2DigestData
                                             md2HexDigest:md2HextDigest
                                                md4Digest:md4DigestData
                                             md4HexDigest:md4HextDigest
                                                md5Digest:md5DigestData
                                             md5HexDigest:md5HextDigest
                                               sha1Digest:sha1DigestData
                                            sha1HexDigest:sha1HextDigest
                                             sha224Digest:sha224DigestData
                                          sha224HexDigest:sha224HextDigest
                                             sha384Digest:sha384DigestData
                                          sha384HexDigest:sha384HextDigest
                                             sha512Digest:sha512DigestData
                                          sha512HexDigest:sha512HextDigest];
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
