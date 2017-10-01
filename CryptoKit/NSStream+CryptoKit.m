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

- (id)withOpenStream:(id (^)(void))callback;

@end

@implementation NSStream (CryptoKit)

#pragma mark - Digests

+ (NSData *)md2HashForInputStream:(NSInputStream *)inputStream
                            error:(NSError *__autoreleasing *)error
{
    NSData *result = [inputStream withOpenStream:^{
      return [inputStream md2Hash:error];
    }];
    return result;
}

+ (NSString *)md2HexHashForInputStream:(NSInputStream *)inputStream
                                 error:(NSError *__autoreleasing *)error
{
    NSString *result = [inputStream withOpenStream:^{
      return [inputStream md2HexHash:error];
    }];
    return result;
}

+ (NSData *)md4HashForInputStream:(NSInputStream *)inputStream
                            error:(NSError *__autoreleasing *)error
{
    NSData *result = [inputStream withOpenStream:^{
      return [inputStream md4Hash:error];
    }];
    return result;
}

+ (NSString *)md4HexHashForInputStream:(NSInputStream *)inputStream
                                 error:(NSError *__autoreleasing *)error
{
    NSString *result = [inputStream withOpenStream:^{
      return [inputStream md4HexHash:error];
    }];
    return result;
}

+ (NSData *)md5HashForInputStream:(NSInputStream *)inputStream
                            error:(NSError *__autoreleasing *)error
{
    NSData *result = [inputStream withOpenStream:^{
      return [inputStream md5Hash:error];
    }];
    return result;
}

+ (NSString *)md5HexHashForInputStream:(NSInputStream *)inputStream
                                 error:(NSError *__autoreleasing *)error
{
    NSString *result = [inputStream withOpenStream:^{
      return [inputStream md5HexHash:error];
    }];
    return result;
}

+ (NSData *)sha1HashForInputStream:(NSInputStream *)inputStream
                             error:(NSError *__autoreleasing *)error
{
    NSData *result = [inputStream withOpenStream:^{
      return [inputStream sha1Hash:error];
    }];
    return result;
}

+ (NSString *)sha1HexHashForInputStream:(NSInputStream *)inputStream
                                  error:(NSError *__autoreleasing *)error
{
    NSString *result = [inputStream withOpenStream:^{
      return [inputStream sha1HexHash:error];
    }];
    return result;
}

+ (NSData *)sha224HashForInputStream:(NSInputStream *)inputStream
                               error:(NSError *__autoreleasing *)error
{
    NSData *result = [inputStream withOpenStream:^{
      return [inputStream sha224Hash:error];
    }];
    return result;
}

+ (NSString *)sha224HexHashForInputStream:(NSInputStream *)inputStream
                                    error:(NSError *__autoreleasing *)error
{
    NSString *result = [inputStream withOpenStream:^{
      return [inputStream sha224HexHash:error];
    }];
    return result;
}

+ (NSData *)sha384HashForInputStream:(NSInputStream *)inputStream
                               error:(NSError *__autoreleasing *)error
{
    NSData *result = [inputStream withOpenStream:^{
      return [inputStream sha384Hash:error];
    }];
    return result;
}

+ (NSString *)sha384HexHashForInputStream:(NSInputStream *)inputStream
                                    error:(NSError *__autoreleasing *)error
{
    NSString *result = [inputStream withOpenStream:^{
      return [inputStream sha384HexHash:error];
    }];
    return result;
}

+ (NSData *)sha512HashForInputStream:(NSInputStream *)inputStream
                               error:(NSError *__autoreleasing *)error
{
    NSData *result = [inputStream withOpenStream:^{
      return [inputStream sha512Hash:error];
    }];
    return result;
}

+ (NSString *)sha512HexHashForInputStream:(NSInputStream *)inputStream
                                    error:(NSError *__autoreleasing *)error
{
    NSString *result = [inputStream withOpenStream:^{
      return [inputStream sha512HexHash:error];
    }];
    return result;
}

#pragma mark + Encryption

+ (BOOL)encryptInputStream:(NSInputStream *)inputStream
            toOutputStream:(NSOutputStream *)outputStream
                  password:(NSString *)password
                     error:(NSError *__autoreleasing *)error
{
    BOOL __block result = NO;
    [inputStream withOpenStream:^id {
      [outputStream withOpenStream:^id {
        result = [inputStream encryptWithPassword:password
                                         toStream:outputStream
                                            error:error];
        return nil;
      }];
      return nil;
    }];
    return result;
}

+ (BOOL)decryptInputStream:(NSInputStream *)inputStream
            toOutputStream:(NSOutputStream *)outputStream
                  password:(NSString *)password
                     error:(NSError *__autoreleasing *)error
{
    BOOL __block result = NO;
    [inputStream withOpenStream:^id {
      [outputStream withOpenStream:^id {
        result = [inputStream decryptWithPassword:password
                                         toStream:outputStream
                                            error:error];
        return nil;
      }];
      return nil;
    }];
    return result;
}

+ (BOOL)recryptInputStream:(NSInputStream *)inputStream
            toOutputStream:(NSOutputStream *)outputStream
                  password:(NSString *)password
               newPassword:(NSString *)newPassword
                     error:(NSError *__nullable __autoreleasing *)error
{
    BOOL __block result = NO;
    [inputStream withOpenStream:^id {
      [outputStream withOpenStream:^id {
        result = [inputStream recryptWithPassword:password
                                      newPassword:newPassword
                                         toStream:outputStream
                                            error:error];
        return nil;
      }];
      return nil; // FIXME
    }];
    return result;
}

@end

#pragma mark - Helpers

@implementation NSStream (CryptoKitPrivate)

- (id)withOpenStream:(id (^)(void))callback
{
    NSStreamStatus initialStatus = [self streamStatus];
    @try {
        if ([self streamStatus] == NSStreamStatusNotOpen) {
            [self open];
        }
        id result = callback();
        return result;
    } @finally {
        if (initialStatus == NSStreamStatusNotOpen) {
            [self close];
        }
    }
}

@end
