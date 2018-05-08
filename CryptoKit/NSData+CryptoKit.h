//
//  NSData+CryptoKit.h
//  CryptoKit
//
//  Created by Andreas Meingast on 10/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

@import Foundation;

@class CKDigestBatchResult;

NS_ASSUME_NONNULL_BEGIN

@interface NSData (CryptoKit)

#pragma mark - Digests

/**
 * Generate the MD2 digest of the NSData instance.
 */
- (nullable NSData *)md2Hash:(NSError *__nullable *)error;

/**
 * Generate the MD2 digest of the NSData instance in a human readable NSString representation.
 */
- (nullable NSString *)md2HexHash:(NSError *__nullable *)error;

/**
 * Generate the MD4 digest of the NSData  instance.
 */
- (nullable NSData *)md4Hash:(NSError *__nullable *)error;

/**
 * Generate the MD4 digest of the NSData instance in a human readable NSString representation.
 */
- (nullable NSString *)md4HexHash:(NSError *__nullable *)error;

/**
 * Generate the MD5 digest of the NSData instance.
 */
- (nullable NSData *)md5Hash:(NSError *__nullable *)error;

/**
 * Generate the MD5 digest of the NSData instance in a human readable NSString representation.
 */
- (nullable NSString *)md5HexHash:(NSError *__nullable *)error;

/**
 * Generate the SHA1 digest of the NSData instance.
 */
- (nullable NSData *)sha1Hash:(NSError *__nullable *)error;

/**
 * Generate the SHA1 digest of the NSData instance in a human readable NSString representation.
 */
- (nullable NSString *)sha1HexHash:(NSError *__nullable *)error;

/**
 * Generate the SHA224 digest of the NSData instance.
 */
- (nullable NSData *)sha224Hash:(NSError *__nullable *)error;

/**
 * Generate the SHA224 digest of the NSData instance in a human readable NSString representation.
 */
- (nullable NSString *)sha224HexHash:(NSError *__nullable *)error;

/**
 * Generate the SHA384 digest of the NSData instance.
 */
- (nullable NSData *)sha384Hash:(NSError *__nullable *)error;

/**
 * Generate the SHA384 digest of the NSData instancein a human readable NSString representation.
 */
- (nullable NSString *)sha384HexHash:(NSError *__nullable *)error;

/**
 * Generate the SHA512 digest of the NSData instance.
 */
- (nullable NSData *)sha512Hash:(NSError *__nullable *)error;

/**
 * Generate the SHA512 digest of the NSData instance in a human readable NSString representation.
 */
- (nullable NSString *)sha512HexHash:(NSError *__nullable *)error;

/**
 * Generate digests of the NSData instance.
 */
- (nullable CKDigestBatchResult *)hashes:(NSError *__nullable *)error;

#pragma mark - Encryption

/**
 * Encrypt the contents of the NSData instance with the provided password and return the result in NSData
 * representation.
 *
 * @warning     The encrypted result is stored in memory. For sufficiently large amounts of data, fall back to
 *              [NSInputStream encryptWithPassword:toStream:error:];
 */
- (nullable NSData *)encryptedDataWithPassword:(NSString *)password
                                         error:(NSError *__nullable *)error;

/**
 * Decrypt the contents of the NSData instance with the provided password and return the result in NSData
 * representation.
 *
 * @warning     The decrypted result is stored in memory. For sufficiently large amounts of data, fall back to
 *              [NSInputStream decryptWithPassword:toStream:error:];
 */
- (nullable NSData *)decryptedDataWithPassword:(NSString *)password
                                         error:(NSError *__nullable *)error;

/**
 * Re-encrypt the contents of the NSData instance previously encrypted with password with the new provided password 
 * and return the result in NSData representation.
 *
 * @warning     The re-encrypted result is stored in memory. For sufficiently large amounts of data, fall back to
 *              [NSInputStream decryptWithPassword:toStream:error:];
 */
- (nullable NSData *)recryptDataWithPassword:(NSString *)password
                                 newPassword:(NSString *)newPassword
                                       error:(NSError *__nullable *)error;

@end

NS_ASSUME_NONNULL_END
