//
//  NSStream+CryptoKit.h
//  CryptoKit
//
//  Created by Andreas Meingast on 11/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSStream (CryptoKit)

#pragma mark - Digests

/**
 * A convenience method for calculating the MD2 digest of contents of the provided inputStream without having to open or
 * close the underlying stream manually.
 */
+ (nullable NSData *)md2HashForInputStream:(NSInputStream *)inputStream
                                     error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the MD2 digest of contents of the provided inputStream in human readable form
 * without having to open or close the underlying stream manually.
 */
+ (nullable NSString *)md2HexHashForInputStream:(NSInputStream *)inputStream
                                          error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the MD4 digest of contents of the provided inputStream without having to open or
 * close the underlying stream manually.
 */
+ (nullable NSData *)md4HashForInputStream:(NSInputStream *)inputStream
                                     error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the MD4 digest of contents of the provided inputStream in human readable form
 * without having to open or close the underlying stream manually.
 */
+ (nullable NSString *)md4HexHashForInputStream:(NSInputStream *)inputStream
                                          error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the MD5 digest of contents of the provided inputStream without having to open or
 * close the underlying stream manually.
 */
+ (nullable NSData *)md5HashForInputStream:(NSInputStream *)inputStream
                                     error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the MD5 digest of contents of the provided inputStream in human readable form
 * without having to open or close the underlying stream manually.
 */
+ (nullable NSString *)md5HexHashForInputStream:(NSInputStream *)inputStream
                                          error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA1 digest of contents of the provided inputStream without having to open
 * or close the underlying stream manually.
 */
+ (nullable NSData *)sha1HashForInputStream:(NSInputStream *)inputStream
                                      error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA1 digest of contents of the provided inputStream in human readable form
 * without having to open or close the underlying stream manually.
 */
+ (nullable NSString *)sha1HexHashForInputStream:(NSInputStream *)inputStream
                                           error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA224 digest of contents of the provided inputStream without having to open
 * or close the underlying stream manually.
 */
+ (nullable NSData *)sha224HashForInputStream:(NSInputStream *)inputStream
                                        error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA224 digest of contents of the provided inputStream in human readable form
 * without having to open or close the underlying stream manually.
 */
+ (nullable NSString *)sha224HexHashForInputStream:(NSInputStream *)inputStream
                                             error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA384 digest of contents of the provided inputStream without having to open
 * or close the underlying stream manually.
 */
+ (nullable NSData *)sha384HashForInputStream:(NSInputStream *)inputStream
                                        error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA384 digest of contents of the provided inputStream in human readable form
 * without having to open or close the underlying stream manually.
 */
+ (nullable NSString *)sha384HexHashForInputStream:(NSInputStream *)inputStream
                                             error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA512 digest of contents of the provided inputStream without having to open
 * or close the underlying stream manually.
 */
+ (nullable NSData *)sha512HashForInputStream:(NSInputStream *)inputStream
                                        error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA512 digest of contents of the provided inputStream in human readable form
 * without having to open or close the underlying stream manually.
 */
+ (nullable NSString *)sha512HexHashForInputStream:(NSInputStream *)inputStream
                                             error:(NSError *__nullable *)error;

#pragma mark - Encryption

/**
 * A convenience method for encrypting inputStreams without having to open or close the underlying streams manually.
 */
+ (BOOL)encryptInputStream:(NSInputStream *)inputStream
            toOutputStream:(NSOutputStream *)outputStream
                  password:(NSString *)password
                     error:(NSError *__nullable *)error;

/**
 * A convenience method for encrypting inputStreams without having to open or close the underlying streams manually.
 */
+ (BOOL)decryptInputStream:(NSInputStream *)inputStream
            toOutputStream:(NSOutputStream *)outputStream
                  password:(NSString *)password
                     error:(NSError *__nullable *)error;

/**
 * A convenience method for re-encrypting inputStreams without having to open or close the underlying streams manually.
 */
+ (BOOL)recryptInputStream:(NSInputStream *)inputStream
            toOutputStream:(NSOutputStream *)outputStream
                  password:(NSString *)password
               newPassword:(NSString *)newPassword
                     error:(NSError *__nullable *)error;
@end

NS_ASSUME_NONNULL_END
