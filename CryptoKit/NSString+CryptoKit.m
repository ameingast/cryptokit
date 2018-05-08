//
//  NSString+CryptoKit.m
//  CryptoKit
//
//  Created by Andreas Meingast on 10/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CryptoKit/NSData+CryptoKit.h>
#import <CryptoKit/NSString+CryptoKit.h>

static const NSStringEncoding OSDefaultStringEncoding = NSUTF8StringEncoding;

@implementation NSString (CococaCryptoHashing)

- (NSData *)md2Hash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data md2Hash:error];
    return result;
}

- (NSString *)md2HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data md2HexHash:error];
    return result;
}

- (NSData *)md4Hash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data md4Hash:error];
    return result;
}

- (NSString *)md4HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data md4HexHash:error];
    return result;
}

- (NSData *)md5Hash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data md5Hash:error];
    return result;
}

- (NSString *)md5HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data md5HexHash:error];
    return result;
}

- (NSData *)sha1Hash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data sha1Hash:error];
    return result;
}

- (NSString *)sha1HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data sha1HexHash:error];
    return result;
}

- (NSData *)sha224Hash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data sha224Hash:error];
    return result;
}

- (NSString *)sha224HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data sha224HexHash:error];
    return result;
}

- (NSData *)sha384Hash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data sha384Hash:error];
    return result;
}

- (NSString *)sha384HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data sha384HexHash:error];
    return result;
}

- (NSData *)sha512Hash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data sha512Hash:error];
    return result;
}

- (NSString *)sha512HexHash:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data sha512HexHash:error];
    return result;
}

- (CKDigestBatchResult *)hashes:(NSError *__autoreleasing *)error
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    CKDigestBatchResult *result = [data hashes:error];
    return result;
}

@end
