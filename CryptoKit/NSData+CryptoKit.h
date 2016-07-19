//
//  NSData+CryptoKit.h
//  CryptoKit
//
//  Created by Andreas Meingast on 10/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSData (CryptoKit)

#pragma mark - Digests

/**
 * Generate the MD2 digest of the NSData instance.
 */
- (NSData *)md2Hash;

/**
 * Generate the MD2 digest of the NSData instance in a human readable NSString representation.
 */
- (NSString *)md2HexHash;

/**
 * Generate the MD4 digest of the NSData  instance.
 */
- (NSData *)md4Hash;

/**
 * Generate the MD4 digest of the NSData instance in a human readable NSString representation.
 */
- (NSString *)md4HexHash;

/**
 * Generate the MD5 digest of the NSData instance.
 */
- (NSData *)md5Hash;

/**
 * Generate the MD5 digest of the NSData instance in a human readable NSString representation.
 */
- (NSString *)md5HexHash;

/**
 * Generate the SHA1 digest of the NSData instance.
 */
- (NSData *)sha1Hash;

/**
 * Generate the SHA1 digest of the NSData instance in a human readable NSString representation.
 */
- (NSString *)sha1HexHash;

/**
 * Generate the SHA224 digest of the NSData instance.
 */
- (NSData *)sha224Hash;

/**
 * Generate the SHA224 digest of the NSData instance in a human readable NSString representation.
 */
- (NSString *)sha224HexHash;

/**
 * Generate the SHA384 digest of the NSData instance.
 */
- (NSData *)sha384Hash;

/**
 * Generate the SHA384 digest of the NSData instancein a human readable NSString representation.
 */
- (NSString *)sha384HexHash;

/**
 * Generate the SHA512 digest of the NSData instance.
 */
- (NSData *)sha512Hash;

/**
 * Generate the SHA512 digest of the NSData instance in a human readable NSString representation.
 */
- (NSString *)sha512HexHash;

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
