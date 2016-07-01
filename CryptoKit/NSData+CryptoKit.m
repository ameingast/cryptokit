//
//  NSData+CryptoKit.m
//  CryptoKit
//
//  Created by Andreas Meingast on 10/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CryptoKit/NSStream+CryptoKit.h>

@implementation NSData (CryptoKit)

#pragma mark - Digests

- (NSData *)md2Hash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream md2HashForInputStream:inputStream
                                               error:nil];
    return result;
}

- (NSString *)md2HexHash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream md2HexHashForInputStream:inputStream error:nil];
    return result;
}

- (NSData *)md4Hash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream md4HashForInputStream:inputStream
                                               error:nil];
    return result;
}

- (NSString *)md4HexHash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream md4HexHashForInputStream:inputStream error:nil];
    return result;
}

- (NSData *)md5Hash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream md5HashForInputStream:inputStream
                                               error:nil];
    return result;
}

- (NSString *)md5HexHash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream md5HexHashForInputStream:inputStream error:nil];
    return result;
}

- (NSData *)sha1Hash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream sha1HashForInputStream:inputStream
                                                error:nil];
    return result;
}

- (NSString *)sha1HexHash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream sha1HexHashForInputStream:inputStream error:nil];
    return result;
}

- (NSData *)sha224Hash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream sha224HashForInputStream:inputStream
                                                  error:nil];
    return result;
}

- (NSString *)sha224HexHash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream sha224HexHashForInputStream:inputStream error:nil];
    return result;
}

- (NSData *)sha384Hash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream sha384HashForInputStream:inputStream
                                                  error:nil];
    return result;
}

- (NSString *)sha384HexHash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream sha384HexHashForInputStream:inputStream error:nil];
    return result;
}

- (NSData *)sha512Hash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream sha512HashForInputStream:inputStream
                                                  error:nil];
    return result;
}

- (NSString *)sha512HexHash
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream sha512HexHashForInputStream:inputStream error:nil];
    return result;
}

#pragma mark - Encryption

- (NSData *)encryptedDataWithPassword:(NSString *)password
                                error:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSOutputStream *outputStream = [NSOutputStream outputStreamToMemory];
    BOOL result = [NSStream encryptInputStream:inputStream
                                toOutputStream:outputStream
                                      password:password
                                         error:error];
    if (!result) {
        return nil;
    }
    NSData *encryptedData = [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    return encryptedData;
}

- (NSData *)decryptedDataWithPassword:(NSString *)password
                                error:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSOutputStream *outputStream = [NSOutputStream outputStreamToMemory];
    BOOL result = [NSStream decryptInputStream:inputStream
                                toOutputStream:outputStream
                                      password:password
                                         error:error];
    if (!result) {
        return nil;
    }
    NSData *decryptedData = [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    return decryptedData;
}

@end
