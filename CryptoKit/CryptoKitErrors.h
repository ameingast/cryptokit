//
//  CryptoKitErrors.h
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 * The error domain/description of all errors and exeptions created by CryptoKit.
 */
extern NSString *const CryptoKitErrorDomain;

/**
 * The error codes used in propagated NSErrors.
 */
typedef NS_ENUM(NSInteger, CryptoKitErrorCode) {
    /// Used for internal, low level errors.
    CryptoKitInternalError = 0,
    /// There was an IO error during stream processing.
    CryptoKitIOError = 1,
    /// The key could not be generated.
    CryptoKitKeyError = 2,
    /// Data provided for decryption does not match on magic byte header.
    CryptoKitMagicNumberMismatch = 3,
    /// Data provided for decryption has incompatible version.
    CryptoKitVersionMismatch = 4,
    /// Data provided for decryption has an invalid header checksum.
    CryptoKitMessageHeaderChecksumMismatch = 5,
    /// Data provided for decryption has an invalid body checksum (caused by data corruption or an invalid password).
    CryptoKitPayloadChecksumMismatch = 6
};

NS_ASSUME_NONNULL_END
