//
//  CryptoKitTypes+CryptoKitPrivate.m
//  CryptoKit
//
//  Created by Andreas Meingast on 29.04.18.
//  Copyright © 2018 Andreas Meingast. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>

#import "CryptoKitTypes.h"
#import "CryptoKitEngine.h"

NSString *const CryptoKitErrorDomain = @"com.operationalsemantics.CryptoKit";

inline NSUInteger CryptoKitDigestTypeSize(CryptoKitDigestType digestType)
{
    switch (digestType) {
        case CryptoKitDigestTypeError:
            return CryptoKitDigestTypeError;
        case CryptoKitDigestTypeMD2:
            return CC_MD2_DIGEST_LENGTH;
        case CryptoKitDigestTypeMD4:
            return CC_MD4_DIGEST_LENGTH;
        case CryptoKitDigestTypeMD5:
            return CC_MD5_DIGEST_LENGTH;
        case CryptoKitDigestTypeSHA1:
            return CC_SHA1_DIGEST_LENGTH;
        case CryptoKitDigestTypeSHA224:
            return CC_SHA224_DIGEST_LENGTH;
        case CryptoKitDigestTypeSHA384:
            return CC_SHA384_DIGEST_LENGTH;
        case CryptoKitDigestTypeSHA512:
            return CC_SHA512_DIGEST_LENGTH;
    }
    return CryptoKitDigestTypeError;
}

inline NSString *NSStringFromCCStatus(CCStatus status)
{
    switch (status) {
        case kCCSuccess:
            return @"Operation completed normally";
        case kCCParamError:
            return @"Illegal parameter value";
        case kCCBufferTooSmall:
            return @"Insufficent buffer provided for specified operation";
        case kCCMemoryFailure:
            return @"Memory allocation failure";
        case kCCAlignmentError:
            return @"Input size was not aligned properly";
        case kCCDecodeError:
            return @"Input data did not decode or decrypt properly";
        case kCCUnimplemented:
            return @"Function not implemented for the current algorithm";
        default:
            return [NSString stringWithFormat:@"Unknown CCStatus: %d", status];
    }
}

@implementation CKDigestBatchResult

@synthesize md2Digest = _md2Digest;
@synthesize md4Digest = _md4Digest;
@synthesize md5Digest = _md5Digest;
@synthesize sha1Digest = _sha1Digest;
@synthesize sha224Digest = _sha224Digest;
@synthesize sha384Digest = _sha384Digest;
@synthesize sha512Digest = _sha512Digest;
@synthesize md2HexDigest = _md2HexDigest;
@synthesize md4HexDigest = _md4HexDigest;
@synthesize md5HexDigest = _md5HexDigest;
@synthesize sha1HexDigest = _sha1HexDigest;
@synthesize sha224HexDigest = _sha224HexDigest;
@synthesize sha384HexDigest = _sha384HexDigest;
@synthesize sha512HexDigest = _sha512HexDigest;

- (CKDigestBatchResult *)initWithMd2Digest:(NSData *)md2Digest
                              md2HexDigest:(NSString *)md2HexDigest
                                 md4Digest:(NSData *)md4Digest
                              md4HexDigest:(NSString *)md4HexDigest
                                 md5Digest:(NSData *)md5Digest
                              md5HexDigest:(NSString *)md5HexDigest
                                sha1Digest:(NSData *)sha1Digest
                             sha1HexDigest:(NSString *)sha1HexDigest
                              sha224Digest:(NSData *)sha224Digest
                           sha224HexDigest:(NSString *)sha224HexDigest
                              sha384Digest:(NSData *)sha384Digest
                           sha384HexDigest:(NSString *)sha384HexDigest
                              sha512Digest:(NSData *)sha512Digest
                           sha512HexDigest:(NSString *)sha512HexDigest
{
    self = [super init];
    if (self) {
        _md2Digest = md2Digest;
        _md2HexDigest = md2HexDigest;
        _md4Digest = md4Digest;
        _md4HexDigest = md4HexDigest;
        _md5Digest = md5Digest;
        _md5HexDigest = md5HexDigest;
        _sha1Digest = sha1Digest;
        _sha1HexDigest = sha1HexDigest;
        _sha224Digest = sha224Digest;
        _sha224HexDigest = sha224HexDigest;
        _sha384Digest = sha384Digest;
        _sha384HexDigest = sha384HexDigest;
        _sha512Digest = sha512Digest;
        _sha512HexDigest = sha512HexDigest;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{md2: %@, md4: %@, md5: %@, sha1: %@, sha224: %@, sha384: %@, sha512: %@}",
            [self md2HexDigest],
            [self md4HexDigest],
            [self md5HexDigest],
            [self sha1HexDigest],
            [self sha224HexDigest],
            [self sha384HexDigest],
            [self sha512HexDigest]];
}

@end
