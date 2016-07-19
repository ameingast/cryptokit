//
//  CryptoKitTypes.m
//  CryptoKit
//
//  Created by Andreas Meingast on 03/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>

#import "CryptoKitTypes.h"

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
