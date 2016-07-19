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
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream md2HashForInputStream:inputStream
                                               error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
    return result;
}

- (NSString *)md2HexHash
{
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream md2HexHashForInputStream:inputStream
                                                    error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
    return result;
}

- (NSData *)md4Hash
{
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream md4HashForInputStream:inputStream
                                               error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
    return result;
}

- (NSString *)md4HexHash
{
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream md4HexHashForInputStream:inputStream
                                                    error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
    return result;
}

- (NSData *)md5Hash
{
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream md5HashForInputStream:inputStream
                                               error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
    return result;
}

- (NSString *)md5HexHash
{
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream md5HexHashForInputStream:inputStream
                                                    error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
    return result;
}

- (NSData *)sha1Hash
{
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream sha1HashForInputStream:inputStream
                                                error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
    return result;
}

- (NSString *)sha1HexHash
{
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream sha1HexHashForInputStream:inputStream
                                                     error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
    return result;
}

- (NSData *)sha224Hash
{
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream sha224HashForInputStream:inputStream
                                                  error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
    return result;
}

- (NSString *)sha224HexHash
{
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream sha224HexHashForInputStream:inputStream
                                                       error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
    return result;
}

- (NSData *)sha384Hash
{
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream sha384HashForInputStream:inputStream
                                                  error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
    return result;
}

- (NSString *)sha384HexHash
{
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream sha384HexHashForInputStream:inputStream
                                                       error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
    return result;
}

- (NSData *)sha512Hash
{
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSData *result = [NSStream sha512HashForInputStream:inputStream
                                                  error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
    return result;
}

- (NSString *)sha512HexHash
{
    NSError *error = nil;
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSString *result = [NSStream sha512HexHashForInputStream:inputStream
                                                       error:&error];
    if (!result) {
        NSLog(@"Fatal: unable to calculate hash for %@ - %@", self, error);
    }
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

- (nullable NSData *)recryptDataWithPassword:(NSString *)password
                                 newPassword:(NSString *)newPassword
                                       error:(NSError *__autoreleasing *)error
{
    NSInputStream *inputStream = [NSInputStream inputStreamWithData:self];
    NSOutputStream *outputStream = [NSOutputStream outputStreamToMemory];
    BOOL result = [NSStream recryptInputStream:inputStream
                                toOutputStream:outputStream
                                      password:password
                                   newPassword:newPassword
                                         error:error];
    if (!result) {
        return nil;
    }
    NSData *recryptedData = [outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    return recryptedData;
}

@end
