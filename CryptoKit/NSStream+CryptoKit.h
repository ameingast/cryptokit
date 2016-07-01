//
//  NSStream+CryptoKit.h
//  CryptoKit
//
//  Created by Andreas Meingast on 11/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStream (CryptoKit)

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Digests

/**
 * A convenience method for calculating the MD2 digest of contents
 * of the provided inputStream without having to open or close 
 * the underlying stream manually.
 *
 * @see     [NSInputStream md2Hash:]
 */
+ (nullable NSData *)md2HashForInputStream:(NSInputStream *)inputStream
                                     error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the MD2 digest of contents
 * of the provided inputStream in human readable form without having 
 * to open or close the underlying stream manually.
 *
 * @see     [NSInputStream md2HexHash:]
 */
+ (nullable NSString *)md2HexHashForInputStream:(NSInputStream *)inputStream
                                          error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the MD4 digest of contents
 * of the provided inputStream without having to open or close
 * the underlying stream manually.
 *
 * @see     [NSInputStream md4Hash:]
 */
+ (nullable NSData *)md4HashForInputStream:(NSInputStream *)inputStream
                                     error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the MD4 digest of contents
 * of the provided inputStream in human readable form without having
 * to open or close the underlying stream manually.
 *
 * @see     [NSInputStream md4HexHash:]
 */
+ (nullable NSString *)md4HexHashForInputStream:(NSInputStream *)inputStream
                                          error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the MD5 digest of contents
 * of the provided inputStream without having to open or close
 * the underlying stream manually.
 *
 * @see     [NSInputStream md5Hash:]
 */
+ (nullable NSData *)md5HashForInputStream:(NSInputStream *)inputStream
                                     error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the MD5 digest of contents
 * of the provided inputStream in human readable form without having
 * to open or close the underlying stream manually.
 *
 * @see     [NSInputStream md5HexHash:]
 */
+ (nullable NSString *)md5HexHashForInputStream:(NSInputStream *)inputStream
                                          error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA1 digest of contents
 * of the provided inputStream without having to open or close
 * the underlying stream manually.
 *
 * @see     [NSInputStream sha1Hash:]
 */
+ (nullable NSData *)sha1HashForInputStream:(NSInputStream *)inputStream
                                      error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA1 digest of contents
 * of the provided inputStream in human readable form without having
 * to open or close the underlying stream manually.
 *
 * @see     [NSInputStream sha1HexHash:]
 */
+ (nullable NSString *)sha1HexHashForInputStream:(NSInputStream *)inputStream
                                           error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA224 digest of contents
 * of the provided inputStream without having to open or close
 * the underlying stream manually.
 *
 * @see     [NSInputStream sha224Hash:]
 */
+ (nullable NSData *)sha224HashForInputStream:(NSInputStream *)inputStream
                                        error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA224 digest of contents
 * of the provided inputStream in human readable form without having
 * to open or close the underlying stream manually.
 *
 * @see     [NSInputStream sha224HexHash:]
 */
+ (nullable NSString *)sha224HexHashForInputStream:(NSInputStream *)inputStream
                                             error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA384 digest of contents
 * of the provided inputStream without having to open or close
 * the underlying stream manually.
 *
 * @see     [NSInputStream sha384Hash:]
 */
+ (nullable NSData *)sha384HashForInputStream:(NSInputStream *)inputStream
                                        error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA384 digest of contents
 * of the provided inputStream in human readable form without having
 * to open or close the underlying stream manually.
 *
 * @see     [NSInputStream sha384HexHash:]
 */
+ (nullable NSString *)sha384HexHashForInputStream:(NSInputStream *)inputStream
                                             error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA512 digest of contents
 * of the provided inputStream without having to open or close
 * the underlying stream manually.
 *
 * @see     [NSInputStream sha512Hash:]
 */
+ (nullable NSData *)sha512HashForInputStream:(NSInputStream *)inputStream
                                        error:(NSError *__nullable *)error;

/**
 * A convenience method for calculating the SHA512 digest of contents
 * of the provided inputStream in human readable form without having
 * to open or close the underlying stream manually.
 *
 * @see     [NSInputStream sha512HexHash:]
 */
+ (nullable NSString *)sha512HexHashForInputStream:(NSInputStream *)inputStream
                                             error:(NSError *__nullable *)error;

#pragma mark - Encryption

/**
 * A convenience method for encrypting inputStreams without having 
 * to open or close the underlying streams manually.
 *
 * @see     [NSInputStream encryptWithPassword:password:error:]
 */
+ (BOOL)encryptInputStream:(NSInputStream *)inputStream
            toOutputStream:(NSOutputStream *)outputStream
                  password:(NSString *)password
                     error:(NSError *__nullable *)error;

/**
 * A convenience method for encrypting inputStreams without having
 * to open or close the underlying streams manually.
 *
 * @see     [NSInputStream decryptWithPassword:password:error:]
 */
+ (BOOL)decryptInputStream:(NSInputStream *)inputStream
            toOutputStream:(NSOutputStream *)outputStream
                  password:(NSString *)password
                     error:(NSError *__nullable *)error;

NS_ASSUME_NONNULL_END

@end
