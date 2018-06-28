//
//  NSURL+CryptoKit.m
//  CryptoKit
//
//  Created by Andreas Meingast on 11/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CryptoKit/NSStream+CryptoKit.h>
#import <CryptoKit/NSURL+CryptoKit.h>

@implementation NSURL (CryptoKit)

#pragma mark - Digests

- (NSData *)md2Hash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSData *result = [NSStream md2HashForInputStream:inputStream
                                               error:error];
    return result;
}

- (NSString *)md2HexHash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSString *result = [NSStream md2HexHashForInputStream:inputStream
                                                    error:error];
    return result;
}

- (NSData *)md4Hash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSData *result = [NSStream md4HashForInputStream:inputStream
                                               error:error];
    return result;
}

- (NSString *)md4HexHash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSString *result = [NSStream md4HexHashForInputStream:inputStream
                                                    error:error];
    return result;
}

- (NSData *)md5Hash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSData *result = [NSStream md5HashForInputStream:inputStream
                                               error:error];
    return result;
}

- (NSString *)md5HexHash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSString *result = [NSStream md5HexHashForInputStream:inputStream
                                                    error:error];
    return result;
}

- (NSData *)sha1Hash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSData *result = [NSStream sha1HashForInputStream:inputStream
                                                error:error];
    return result;
}

- (NSString *)sha1HexHash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSString *result = [NSStream sha1HexHashForInputStream:inputStream
                                                     error:error];
    return result;
}

- (NSData *)sha224Hash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSData *result = [NSStream sha224HashForInputStream:inputStream
                                                  error:error];
    return result;
}

- (NSString *)sha224HexHash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSString *result = [NSStream sha224HexHashForInputStream:inputStream
                                                       error:error];
    return result;
}

- (NSData *)sha384Hash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSData *result = [NSStream sha384HashForInputStream:inputStream
                                                  error:error];
    return result;
}

- (NSString *)sha384HexHash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSString *result = [NSStream sha384HexHashForInputStream:inputStream
                                                       error:error];
    return result;
}

- (NSData *)sha512Hash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSData *result = [NSStream sha512HashForInputStream:inputStream
                                                  error:error];
    return result;
}

- (NSString *)sha512HexHash:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSString *result = [NSStream sha512HexHashForInputStream:inputStream
                                                       error:error];
    return result;
}

- (CKDigestBatchResult *)hashes:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    CKDigestBatchResult *result = [NSStream hashesForInputStream:inputStream
                                                                          error:error];
    return result;
}

#pragma mark - Encryption

- (BOOL)encryptedURLWithPassword:(NSString *)password
                       targetURL:(NSURL *)targetURL
                           error:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSOutputStream *outputStream = [NSOutputStream outputStreamWithURL:targetURL
                                                                append:NO];
    BOOL result = [NSStream encryptInputStream:inputStream
                                toOutputStream:outputStream
                                      password:password
                                         error:error];
    return result;
}

- (BOOL)decryptedURLWithPassword:(NSString *)password
                       targetURL:(NSURL *)targetURL
                           error:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSOutputStream *outputStream = [NSOutputStream outputStreamWithURL:targetURL
                                                                append:NO];
    BOOL result = [NSStream decryptInputStream:inputStream
                                toOutputStream:outputStream
                                      password:password
                                         error:error];
    return result;
}

- (BOOL)recryptedURLWithPassword:(NSString *)password
                     newPassword:(NSString *)newPassword
                       targetURL:(NSURL *)targetURL
                           error:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:self];
    NSOutputStream *outputStream = [NSOutputStream outputStreamWithURL:targetURL
                                                                append:NO];
    BOOL result = [NSStream recryptInputStream:inputStream
                                toOutputStream:outputStream
                                      password:password
                                   newPassword:newPassword
                                         error:error];
    return result;
}

#pragma mark - Partitioning

- (BOOL)disassembleFromURLWithpartitionStrategy:(CKPartitionStrategy)partitionStrategy
                                       password:(NSString *)password
                                   chunkHandler:(CKChunkHandler)chunkHandler
                                          error:(NSError *__autoreleasing *)error
{
    NSInputStream *inputSTream = [NSInputStream inputStreamWithURL:self];
    BOOL result = [NSStream disassembleFromInputStream:inputSTream
                                     partitionStrategy:partitionStrategy
                                              password:password
                                          chunkHandler:chunkHandler
                                                 error:error];
    return result;
}

- (BOOL)assembleToURLWithPassword:(NSString *)password
                    chunkProvider:(CKChunkProvider)chunkProvider
                            error:(NSError *__autoreleasing *)error
{
    NSOutputStream *outputStream = [NSOutputStream outputStreamWithURL:self
                                                                append:NO];
    BOOL result = [NSStream assembleToOutputStream:outputStream
                                          password:password
                                     chunkProvider:chunkProvider
                                             error:error];
    return result;
}

@end
