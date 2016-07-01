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

- (NSData *)md2Hash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data md2Hash];
    return result;
}

- (NSString *)md2HexHash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data md2HexHash];
    return result;
}

- (NSData *)md4Hash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data md4Hash];
    return result;
}

- (NSString *)md4HexHash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data md4HexHash];
    return result;
}

- (NSData *)md5Hash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data md5Hash];
    return result;
}

- (NSString *)md5HexHash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data md5HexHash];
    return result;
}

- (NSData *)sha1Hash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data sha1Hash];
    return result;
}

- (NSString *)sha1HexHash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data sha1HexHash];
    return result;
}

- (NSData *)sha224Hash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data sha224Hash];
    return result;
}

- (NSString *)sha224HexHash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data sha224HexHash];
    return result;
}

- (NSData *)sha384Hash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data sha384Hash];
    return result;
}

- (NSString *)sha384HexHash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data sha384HexHash];
    return result;
}

- (NSData *)sha512Hash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSData *result = [data sha512Hash];
    return result;
}

- (NSString *)sha512HexHash
{
    NSData *data = [self dataUsingEncoding:OSDefaultStringEncoding
                      allowLossyConversion:NO];
    NSString *result = [data sha512HexHash];
    return result;
}

@end
