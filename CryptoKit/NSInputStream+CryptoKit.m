//
//  NSInputStream+CryptoKit.m
//  CryptoKit
//
//  Created by Andreas Meingast on 10/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CryptoKit/CryptoKitEngine.h>
#import <CryptoKit/NSInputStream+CryptoKit.h>

@implementation NSInputStream (CryptoKit)

#pragma mark - Digests

- (NSData *)md2Hash:(NSError *__autoreleasing *)error
{
    NSData *result = NSDataWithDigestFromInputStream(self, CryptoKitDigestTypeMD2, error);
    return result;
}

- (NSString *)md2HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self md2Hash:error];
    NSString *result = NSStringAsDigestFromData(data, CryptoKitDigestTypeMD2);
    return result;
}

- (NSData *)md4Hash:(NSError *__autoreleasing *)error
{
    NSData *result = NSDataWithDigestFromInputStream(self, CryptoKitDigestTypeMD4, error);
    return result;
}

- (NSString *)md4HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self md4Hash:error];
    NSString *result = NSStringAsDigestFromData(data, CryptoKitDigestTypeMD4);
    return result;
}

- (NSData *)md5Hash:(NSError *__autoreleasing *)error
{
    NSData *result = NSDataWithDigestFromInputStream(self, CryptoKitDigestTypeMD5, error);
    return result;
}

- (NSString *)md5HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self md5Hash:error];
    NSString *result = NSStringAsDigestFromData(data, CryptoKitDigestTypeMD5);
    return result;
}

- (NSData *)sha1Hash:(NSError *__autoreleasing *)error
{
    NSData *result = NSDataWithDigestFromInputStream(self, CryptoKitDigestTypeSHA1, error);
    return result;
}

- (NSString *)sha1HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self sha1Hash:error];
    NSString *result = NSStringAsDigestFromData(data, CryptoKitDigestTypeSHA1);
    return result;
}

- (NSData *)sha224Hash:(NSError *__autoreleasing *)error
{
    NSData *result = NSDataWithDigestFromInputStream(self, CryptoKitDigestTypeSHA224, error);
    return result;
}

- (NSString *)sha224HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self sha224Hash:error];
    NSString *result = NSStringAsDigestFromData(data, CryptoKitDigestTypeSHA224);
    return result;
}

- (NSData *)sha384Hash:(NSError *__autoreleasing *)error
{
    NSData *result = NSDataWithDigestFromInputStream(self, CryptoKitDigestTypeSHA384, error);
    return result;
}

- (NSString *)sha384HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self sha384Hash:error];
    NSString *result = NSStringAsDigestFromData(data, CryptoKitDigestTypeSHA384);
    return result;
}

- (NSData *)sha512Hash:(NSError *__autoreleasing *)error
{
    NSData *result = NSDataWithDigestFromInputStream(self, CryptoKitDigestTypeSHA512, error);
    return result;
}

- (NSString *)sha512HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self sha512Hash:error];
    NSString *result = NSStringAsDigestFromData(data, CryptoKitDigestTypeSHA512);
    return result;
}

#pragma mark - Encryption

- (BOOL)encryptWithPassword:(NSString *)password
                   toStream:(NSOutputStream *)outputStream
                      error:(NSError *__autoreleasing *)error

{
    BOOL result = CryptoKitEncryptStream(self, outputStream, password, error);
    return result;
}

- (BOOL)decryptWithPassword:(NSString *)password
                   toStream:(NSOutputStream *)outputStream
                      error:(NSError *__autoreleasing *)error
{
    BOOL result = CryptoKitDecryptStream(self, outputStream, password, error);
    return result;
}

@end
