//
//  NSStream+CryptoKit.m
//  CryptoKit
//
//  Created by Andreas Meingast on 11/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CryptoKit/NSInputStream+CryptoKit.h>
#import <CryptoKit/NSStream+CryptoKit.h>

#pragma mark - Helpers

@interface NSStream (CryptoKitPrivate)

- (void)withOpenStream:(void (^)())callback;

@end

@implementation NSStream (CryptoKit)

#pragma mark - Digests

+ (NSData *)md2HashForInputStream:(NSInputStream *)inputStream
                            error:(NSError *__autoreleasing *)error
{
    NSData __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream md2Hash:error];
    }];
    return result;
}

+ (NSString *)md2HexHashForInputStream:(NSInputStream *)inputStream
                                 error:(NSError *__autoreleasing *)error
{
    NSString __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream md2HexHash:error];
    }];
    return result;
}

+ (NSData *)md4HashForInputStream:(NSInputStream *)inputStream
                            error:(NSError *__autoreleasing *)error
{
    NSData __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream md4Hash:error];
    }];
    return result;
}

+ (NSString *)md4HexHashForInputStream:(NSInputStream *)inputStream
                                 error:(NSError *__autoreleasing *)error
{
    NSString __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream md4HexHash:error];
    }];
    return result;
}

+ (NSData *)md5HashForInputStream:(NSInputStream *)inputStream
                            error:(NSError *__autoreleasing *)error
{
    NSData __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream md5Hash:error];
    }];
    return result;
}

+ (NSString *)md5HexHashForInputStream:(NSInputStream *)inputStream
                                 error:(NSError *__autoreleasing *)error
{
    NSString __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream md5HexHash:error];
    }];
    return result;
}

+ (NSData *)sha1HashForInputStream:(NSInputStream *)inputStream
                             error:(NSError *__autoreleasing *)error
{
    NSData __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream sha1Hash:error];
    }];
    return result;
}

+ (NSString *)sha1HexHashForInputStream:(NSInputStream *)inputStream
                                  error:(NSError *__autoreleasing *)error
{
    NSString __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream sha1HexHash:error];
    }];
    return result;
}

+ (NSData *)sha224HashForInputStream:(NSInputStream *)inputStream
                               error:(NSError *__autoreleasing *)error
{
    NSData __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream sha224Hash:error];
    }];
    return result;
}

+ (NSString *)sha224HexHashForInputStream:(NSInputStream *)inputStream
                                    error:(NSError *__autoreleasing *)error
{
    NSString __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream sha224HexHash:error];
    }];
    return result;
}

+ (NSData *)sha384HashForInputStream:(NSInputStream *)inputStream
                               error:(NSError *__autoreleasing *)error
{
    NSData __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream sha384Hash:error];
    }];
    return result;
}

+ (NSString *)sha384HexHashForInputStream:(NSInputStream *)inputStream
                                    error:(NSError *__autoreleasing *)error
{
    NSString __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream sha384HexHash:error];
    }];
    return result;
}

+ (NSData *)sha512HashForInputStream:(NSInputStream *)inputStream
                               error:(NSError *__autoreleasing *)error
{
    NSData __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream sha512Hash:error];
    }];
    return result;
}

+ (NSString *)sha512HexHashForInputStream:(NSInputStream *)inputStream
                                    error:(NSError *__autoreleasing *)error
{
    NSString __block *result;
    [inputStream withOpenStream:^{
      result = [inputStream sha512HexHash:error];
    }];
    return result;
}

#pragma mark + Encryption

+ (BOOL)encryptInputStream:(NSInputStream *)inputStream
            toOutputStream:(NSOutputStream *)outputStream
                  password:(NSString *)password
                     error:(NSError *__autoreleasing *)error
{
    BOOL __block result;
    [inputStream withOpenStream:^{
      [outputStream withOpenStream:^{
        result = [inputStream encryptWithPassword:password
                                         toStream:outputStream
                                            error:error];
      }];
    }];
    return result;
}

+ (BOOL)decryptInputStream:(NSInputStream *)inputStream
            toOutputStream:(NSOutputStream *)outputStream
                  password:(NSString *)password
                     error:(NSError *__autoreleasing *)error
{
    BOOL __block result;
    [inputStream withOpenStream:^{
      [outputStream withOpenStream:^{
        result = [inputStream decryptWithPassword:password
                                         toStream:outputStream
                                            error:error];
      }];
    }];
    return result;
}

@end

#pragma mark - Helpers

@implementation NSStream (CryptoKitPrivate)

- (void)withOpenStream:(void (^)())callback
{
    BOOL initialStatus = [self streamStatus];
    @try {
        if ([self streamStatus] == NSStreamStatusNotOpen) {
            [self open];
        }
        callback();
    } @finally {
        if (initialStatus == NSStreamStatusNotOpen) {
            [self close];
        }
    }
}

@end
