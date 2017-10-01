//
//  NSInputStream+CryptoKit.m
//  CryptoKit
//
//  Created by Andreas Meingast on 10/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CryptoKit/NSInputStream+CryptoKit.h>

#import "CryptoKitEngine.h"

@interface NSInputStream (CryptoKitPrivate)

- (CryptoKitEngine *)engine;

@end

@implementation NSInputStream (CryptoKit)

#pragma mark - Digests

- (NSData *)md2Hash:(NSError *__autoreleasing *)error
{
    NSData *result = [self.engine calculateDigest:self
                                       digestType:CryptoKitDigestTypeMD2
                                            error:error];
    return result;
}

- (NSString *)md2HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self md2Hash:error];
    if (!data) {
        return nil;
    }
    NSString *result = [self.engine digestToHumanReadableRepresentation:data
                                                             digestType:CryptoKitDigestTypeMD2
                                                                  error:error];
    return result;
}

- (NSData *)md4Hash:(NSError *__autoreleasing *)error
{
    NSData *result = [self.engine calculateDigest:self
                                       digestType:CryptoKitDigestTypeMD4
                                            error:error];
    return result;
}

- (NSString *)md4HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self md4Hash:error];
    if (!data) {
        return nil;
    }
    NSString *result = [self.engine digestToHumanReadableRepresentation:data
                                                             digestType:CryptoKitDigestTypeMD4
                                                                  error:error];
    return result;
}

- (NSData *)md5Hash:(NSError *__autoreleasing *)error
{
    NSData *result = [self.engine calculateDigest:self
                                       digestType:CryptoKitDigestTypeMD5
                                            error:error];
    return result;
}

- (NSString *)md5HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self md5Hash:error];
    if (!data) {
        return nil;
    }
    NSString *result = [self.engine digestToHumanReadableRepresentation:data
                                                             digestType:CryptoKitDigestTypeMD5
                                                                  error:error];
    return result;
}

- (NSData *)sha1Hash:(NSError *__autoreleasing *)error
{
    NSData *result = [self.engine calculateDigest:self
                                       digestType:CryptoKitDigestTypeSHA1
                                            error:error];
    return result;
}

- (NSString *)sha1HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self sha1Hash:error];
    if (!data) {
        return nil;
    }
    NSString *result = [self.engine digestToHumanReadableRepresentation:data
                                                             digestType:CryptoKitDigestTypeSHA1
                                                                  error:error];
    return result;
}

- (NSData *)sha224Hash:(NSError *__autoreleasing *)error
{
    NSData *result = [self.engine calculateDigest:self
                                       digestType:CryptoKitDigestTypeSHA224
                                            error:error];
    return result;
}

- (NSString *)sha224HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self sha224Hash:error];
    if (!data) {
        return nil;
    }
    NSString *result = [self.engine digestToHumanReadableRepresentation:data
                                                             digestType:CryptoKitDigestTypeSHA224
                                                                  error:error];
    return result;
}

- (nullable NSData *)sha384Hash:(NSError *__autoreleasing *)error
{
    NSData *result = [self.engine calculateDigest:self
                                       digestType:CryptoKitDigestTypeSHA384
                                            error:error];
    return result;
}

- (NSString *)sha384HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self sha384Hash:error];
    if (!data) {
        return nil;
    }
    NSString *result = [self.engine digestToHumanReadableRepresentation:data
                                                             digestType:CryptoKitDigestTypeSHA384
                                                                  error:error];
    return result;
}

- (NSData *)sha512Hash:(NSError *__autoreleasing *)error
{
    NSData *result = [self.engine calculateDigest:self
                                       digestType:CryptoKitDigestTypeSHA512
                                            error:error];
    return result;
}

- (NSString *)sha512HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self sha512Hash:error];
    if (!data) {
        return nil;
    }
    NSString *result = [self.engine digestToHumanReadableRepresentation:data
                                                             digestType:CryptoKitDigestTypeSHA512
                                                                  error:error];
    return result;
}

#pragma mark - Encryption

- (BOOL)encryptWithPassword:(NSString *)password
                   toStream:(NSOutputStream *)outputStream
                      error:(NSError *__autoreleasing *)error

{
    BOOL result = [self.engine encryptStream:self
                                outputStream:outputStream
                                    password:password
                                       error:error];
    return result;
}

- (BOOL)decryptWithPassword:(NSString *)password
                   toStream:(NSOutputStream *)outputStream
                      error:(NSError *__autoreleasing *)error
{
    BOOL result = [self.engine decryptStream:self
                                outputStream:outputStream
                                    password:password
                                       error:error];
    return result;
}

- (BOOL)recryptWithPassword:(NSString *)password
                newPassword:(NSString *)newPassword
                   toStream:(NSOutputStream *)outputStream
                      error:(NSError *__nullable __autoreleasing *)error

{
    BOOL result = [self.engine recryptInputStream:self
                                   toOutputStream:outputStream
                                         password:password
                                      newPassword:newPassword
                                            error:error];
    return result;
}

@end

@implementation NSInputStream (CryptoKitPrivate)

- (CryptoKitEngine *)engine
{
    return [CryptoKitEngine sharedInstance];
}

@end
