//
//  NSURL+CryptoKit.h
//  CryptoKit
//
//  Created by Andreas Meingast on 11/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CryptoKit)

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Digests

/**
 * Generate the MD2 digest of the NSURL instance.
 */
- (nullable NSData *)md2Hash:(NSError *__nullable *)error;

/**
 * Generate the MD2 digest of the NSURL instance 
 * in a human readable NSString representation.
 */
- (nullable NSString *)md2HexHash:(NSError *__nullable *)error;

/**
 * Generate the MD4 digest of the NSURL instance.
 */
- (nullable NSData *)md4Hash:(NSError *__nullable *)error;

/**
 * Generate the MD4 digest of the NSURL instance
 * in a human readable NSString representation.
 */
- (nullable NSString *)md4HexHash:(NSError *__nullable *)error;

/**
 * Generate the MD5 digest of the NSURL instance.
 */
- (nullable NSData *)md5Hash:(NSError *__nullable *)error;

/**
 * Generate the MD5 digest of the NSURL instance
 * in a human readable NSString representation.
 */
- (nullable NSString *)md5HexHash:(NSError *__nullable *)error;

/**
 * Generate the SHA1 digest of the NSURL instance.
 */
- (nullable NSData *)sha1Hash:(NSError *__nullable *)error;

/**
 * Generate the SHA1 digest of the NSURL instance 
 * in a human readable NSString representation.
 */
- (nullable NSString *)sha1HexHash:(NSError *__nullable *)error;

/**
 * Generate the SHA224 digest of the NSURL instance.
 */
- (nullable NSData *)sha224Hash:(NSError *__nullable *)error;

/**
 * Generate the SHA224 digest of the NSURL instance
 * in a human readable NSString representation.
 */
- (nullable NSString *)sha224HexHash:(NSError *__nullable *)error;

/**
 * Generate the SHA384 digest of the NSURL instance.
 */
- (nullable NSData *)sha384Hash:(NSError *__nullable *)error;

/**
 * Generate the SHA384 digest of the NSURL instance
 * in a human readable NSString representation.
 */
- (nullable NSString *)sha384HexHash:(NSError *__nullable *)error;

/**
 * Generate the SHA512 digest of the NSURL instance.
 */
- (nullable NSData *)sha512Hash:(NSError *__nullable *)error;

/**
 * Generate the SHA512 digest of the NSURL instance
 * in a human readable NSString representation.
 */
- (nullable NSString *)sha512HexHash:(NSError *__nullable *)error;

#pragma mark - Encryption

/**
 * Encrypt the contents of the NSURL instance and write 
 * the result to targetURL.
 * 
 * @warning     This method will block the current thread
 *              until all data from the NSURL instance
 *              is consumed, encrypted and written to the
 *              targetURL.
 */
- (BOOL)encryptedURLWithPassword:(NSString *)password
                       targetURL:(NSURL *)targetURL
                           error:(NSError *__nullable *)error;

/**
 * Decrypt the contents of the NSURL instance and write
 * the result to targetURL.
 *
 * @warning     This method will block the current thread
 *              until all data from the NSURL instance
 *              is consumed, decrypted and written to the
 *              targetURL.
 */
- (BOOL)decryptedURLWithPassword:(NSString *)password
                       targetURL:(NSURL *)targetURL
                           error:(NSError *__nullable *)error;

NS_ASSUME_NONNULL_END

@end
