//
//  CryptoKitEngine.h
//  CryptoKit
//
//  Created by Andreas Meingast on 09/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import <Foundation/Foundation.h>

/**
 * This module contains the heavy-lifting crypto and digest logic
 * of this framework. It's the only part of the framework
 * that interfaces with CommonCrypto.
 *
 * It provides convenience functions to calculate digests and 
 * a stream-based encryption/decryption wrapper with metadata 
 * support around the CommonCrypto lower level C-API.
 */

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Errors

/**
 * The error domain/description of all errors and exeptions created by CryptoKit.
 */
extern NSString *const CryptoKitErrorDomain;

/**
 * The error codes used in propagated NSErrors.
 */
typedef NS_ENUM(NSUInteger, CryptoKitErrorCode) {
    /// A generic IO error.
    CryptoKitIOError,
    /// A key-generation error.
    CryptoKitKeyError,
    /// An internal error.
    CryptoKitInternalError
};

#pragma mark - Digests

/**
 * CryptoKitDigestType represents a checksum digest algorithm.
 */
typedef NS_ENUM(NSUInteger, CryptoKitDigestType) {
    CryptoKitDigestTypeMD2,
    CryptoKitDigestTypeMD4,
    CryptoKitDigestTypeMD5,
    CryptoKitDigestTypeSHA1,
    CryptoKitDigestTypeSHA224,
    CryptoKitDigestTypeSHA384,
    CryptoKitDigestTypeSHA512
};

/**
 * Calculate the checksum for contents of inputStream and return it in raw NSData form.
 */
NSData *__nullable NSDataWithDigestFromInputStream(NSInputStream *inputStream,
                                                   CryptoKitDigestType digestType,
                                                   NSError *__nullable *error);

/**
 * Calculate the string representation of the provided
 * digest-data using the algorithm represented by
 * digestType.
 */
NSString *NSStringAsDigestFromData(NSData *data,
                                   CryptoKitDigestType digestType);

#pragma mark - NSStream Encryption

/**
 * Encrypt the contents of inputStream using a given password 
 * and write the encrypted result to outputStream.
 *
 * The encrypted data contains a 256 byte header containing
 * meta information and encryption data such as the 
 * initialization vector and salt.
 *
 * All errors are reported through a falsy return value and
 * an NSError object.
 *
 * The data layout looks as follows:
 *
 * @code
 *  |===============================|
 *  | FROM | TO  | SIZE | SEMANTICS |
 *  |===============================|
 *  | 0    | 3   | 4B   | VERSION   |
 *  |--------------------------------
 *  | 4    | 19  | 16B  | IV        |
 *  |--------------------------------
 *  | 20   | 83  | 64B  | SALT      |
 *  |--------------------------------
 *  | 84   | 255 | 172B | RESERVED  |
 *  |--------------------------------
 *  | 256  | EOF | -    | PAYLOAD   |
 *  |===============================|
 * @endcode
 */
BOOL CryptoKitEncryptStream(NSInputStream *inputStream,
                            NSOutputStream *outputStream,
                            NSString *password,
                            NSError *__nullable *error);

/** 
 * Decrypt the contents of inputStream using a given password
 * and write the decrypted result to outputStream.
 *
 * This method assumes that the inputStream contains data 
 * encrypted with CryptoKitEncryptStream.
 *
 * All errors are reported through a falsy return value and
 * an NSError object.
 */
BOOL CryptoKitDecryptStream(NSInputStream *inputStream,
                            NSOutputStream *outputStream,
                            NSString *password,
                            NSError *__nullable *error);

NS_ASSUME_NONNULL_END
