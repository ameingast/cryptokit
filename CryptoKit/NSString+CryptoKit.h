//
//  NSString+CryptoKit.h
//  CryptoKit
//
//  Created by Andreas Meingast on 10/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CococaCryptoHashing)

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Digests

/**
 * Generate the MD2 digest of the NSString instance.
 */
- (NSData *)md2Hash;

/**
 * Generate the MD2 digest of the NSString instance 
 * in a human readable NSString representation.
 */
- (NSString *)md2HexHash;

/**
 * Generate the MD4 digest of the NSString instance.
 */
- (NSData *)md4Hash;

/**
 * Generate the MD4 digest of the NSString instance 
 * in a human readable NSString representation.
 */
- (NSString *)md4HexHash;

/**
 * Generate the MD5 digest of the NSString instance.
 */
- (NSData *)md5Hash;

/**
 * Generate the MD5 digest of the NSString instance 
 * in a human readable NSString representation.
 */
- (NSString *)md5HexHash;

/**
 * Generate the SHA1 digest of the NSString instance.
 */
- (NSData *)sha1Hash;

/**
 * Generate the SHA1 digest of the NSString instance 
 * in a human readable NSString representation.
 */
- (NSString *)sha1HexHash;

/**
 * Generate the SHA224 digest of the NSString instance.
 */
- (NSData *)sha224Hash;

/**
 * Generate the SHA224 digest of the NSString instance 
 * in a human readable NSString representation.
 */
- (NSString *)sha224HexHash;

/**
 * Generate the SHA384 digest of the NSString instance.
 */
- (NSData *)sha384Hash;

/**
 * Generate the SHA384 digest of the NSString instance 
 * in a human readable NSString representation.
 */
- (NSString *)sha384HexHash;

/**
 * Generate the SHA512 digest of the NSString instance.
 */
- (NSData *)sha512Hash;

/**
 * Generate the SHA512 digest of the NSString instance 
 * in a human readable NSString representation.
 */
- (NSString *)sha512HexHash;

NS_ASSUME_NONNULL_END

@end
