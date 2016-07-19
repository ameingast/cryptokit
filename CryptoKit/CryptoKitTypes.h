//
//  CryptoKitTypes.h
//  CryptoKit
//
//  Created by Andreas Meingast on 03/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CryptoKitDigestType) {
    CryptoKitDigestTypeError = 0,
    CryptoKitDigestTypeMD2 = 1,
    CryptoKitDigestTypeMD4 = 2,
    CryptoKitDigestTypeMD5 = 3,
    CryptoKitDigestTypeSHA1 = 4,
    CryptoKitDigestTypeSHA224 = 5,
    CryptoKitDigestTypeSHA384 = 6,
    CryptoKitDigestTypeSHA512 = 7
};

NSUInteger CryptoKitDigestTypeSize(CryptoKitDigestType type);
NSString *NSStringFromCCStatus(int32_t status);

NS_ASSUME_NONNULL_END
