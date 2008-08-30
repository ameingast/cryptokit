/*
 * CocoaCryptoHashing.m
 * CocoaCryptoHashing
 * 
 * Copyright (c)        2004-2005       Denis Defreyne
 *                      2006            Andreas Meingast
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * 
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * - The names of its contributors may not be used to endorse or promote
 *   products derived from this software without specific prior written
 *   permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "CocoaCryptoHashing.h"
#include <openssl/evp.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

#define BUFSIZE                 (1024 * 16)
#define HEXDIGEST_LENGTH(x)     (x * 2)

extern int errno;

static NSData *digestForData(NSData *data, const EVP_MD *md);
static NSData *digestForFile(int fileDescriptor, const EVP_MD *md);
static NSString *digestToHex(NSData *data, int digestLength);

@implementation NSString (CocoaCryptoHashing)

- (NSData *)md2Hash
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] md2Hash];
}

- (NSString *)md2HexHash
{
        return digestToHex([self md2Hash], MD2_DIGEST_LENGTH);
}

- (NSData *)md4Hash
{
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] md4Hash];
}

- (NSString *)md4HexHash
{
        return digestToHex([self md4Hash], MD4_DIGEST_LENGTH);
}

- (NSData *)md5Hash
{
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] md5Hash];
}

- (NSString *)md5HexHash
{
        return digestToHex([self md5Hash], MD5_DIGEST_LENGTH);
}

- (NSData *)rmd160Hash
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] rmd160Hash];
}

- (NSString *)rmd160HexHash
{
        return digestToHex([self rmd160Hash], RIPEMD160_DIGEST_LENGTH);
}

- (NSData *)shaHash
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] shaHash];
}

- (NSString *)shaHexHash
{
        return digestToHex([self shaHash], SHA_DIGEST_LENGTH);
}

- (NSData *)sha1Hash
{
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] sha1Hash];
}

- (NSString *)sha1HexHash
{
        return digestToHex([self sha1Hash], SHA_DIGEST_LENGTH);
}

@end

@implementation NSData (CocoaCryptoHashing)

- (NSData *)md2Hash
{
        return digestForData(self, EVP_md2());
}

- (NSString *)md2HexHash
{
        return digestToHex([self md2Hash], MD2_DIGEST_LENGTH);
}

- (NSData *)md4Hash
{
        return digestForData(self, EVP_md4());
}

- (NSString *)md4HexHash
{	
        return digestToHex([self md4Hash], MD4_DIGEST_LENGTH);
}

- (NSData *)md5Hash
{
        return digestForData(self, EVP_md5());
}

- (NSString *)md5HexHash
{
        return digestToHex([self md5Hash], MD5_DIGEST_LENGTH);
}

- (NSData *)rmd160Hash
{
        return digestForData(self, EVP_ripemd160());
}

- (NSString *)rmd160HexHash
{
        return digestToHex([self rmd160Hash], RIPEMD160_DIGEST_LENGTH);
}

- (NSData *)shaHash
{
        return digestForData(self, EVP_sha());
}

- (NSString *)shaHexHash
{
        return digestToHex([self shaHash], SHA_DIGEST_LENGTH);
}

- (NSData *)sha1Hash
{
        return digestForData(self, EVP_sha1()); 
}

- (NSString *)sha1HexHash
{
        return digestToHex([self sha1Hash], SHA_DIGEST_LENGTH);
}

@end

@implementation NSFileHandle (CocoaCryptoHashing)

- (NSData *)md2Hash
{
        [self seekToFileOffset:0];
        return digestForFile([self fileDescriptor], EVP_md2());
}

- (NSString *)md2HexHash
{
        return digestToHex([self md2Hash], MD2_DIGEST_LENGTH);
}

- (NSData *)md4Hash
{
        [self seekToFileOffset:0];
        return digestForFile([self fileDescriptor], EVP_md4());
}

- (NSString *)md4HexHash
{
        return digestToHex([self md4Hash], MD4_DIGEST_LENGTH);
}

- (NSData *)md5Hash
{
        [self seekToFileOffset:0];
        return digestForFile([self fileDescriptor], EVP_md5());
}

- (NSString *)md5HexHash
{
        return digestToHex([self md5Hash], MD5_DIGEST_LENGTH);
}

- (NSData *)rmd160Hash
{
        [self seekToFileOffset:0];
        return digestForFile([self fileDescriptor], EVP_ripemd160());
}

- (NSString *)rmd160HexHash
{
        return digestToHex([self rmd160Hash], RIPEMD160_DIGEST_LENGTH);
}

- (NSData *)shaHash
{
        [self seekToFileOffset:0];
        return digestForFile([self fileDescriptor], EVP_sha());
}

- (NSString *)shaHexHash
{
        return digestToHex([self shaHash], SHA_DIGEST_LENGTH);
}

- (NSData *)sha1Hash
{
        [self seekToFileOffset:0];
        return digestForFile([self fileDescriptor], EVP_sha1());
}

- (NSString *)sha1HexHash
{
        return digestToHex([self sha1Hash], SHA_DIGEST_LENGTH);
}

@end

static NSData *digestForData(NSData *data, const EVP_MD *md)
{
        EVP_MD_CTX mdctx;
        unsigned int md_len;
        unsigned char md_value[EVP_MAX_MD_SIZE];
        
        EVP_MD_CTX_init(&mdctx);
        EVP_DigestInit_ex(&mdctx, md, NULL);
        EVP_DigestUpdate(&mdctx, [data bytes], [data length]);
        EVP_DigestFinal_ex(&mdctx, md_value, &md_len);
        EVP_MD_CTX_cleanup(&mdctx);
        return [NSData dataWithBytes:&md_value length:md_len];
}

static NSData *digestForFile(int fileDescriptor, const EVP_MD *md)
{
        EVP_MD_CTX mdctx;
        ssize_t i;
        unsigned char buf[BUFSIZE];
        unsigned char md_value[EVP_MAX_MD_SIZE];
        unsigned int md_len;
        
        EVP_MD_CTX_init(&mdctx);
        EVP_DigestInit_ex(&mdctx, md, NULL);
        for (;;) {
                i = read(fileDescriptor, buf, sizeof(buf));
                if (0 == i) {
                        break;
                } else if (-1 == i) {
                        [[NSException exceptionWithName:@"DigestException" 
                                                 reason:[NSString stringWithCString:strerror(errno)]
                                               userInfo:nil] raise];
                } else {
                        EVP_DigestUpdate(&mdctx, buf, i);
                }
        }
        EVP_DigestFinal_ex(&mdctx, md_value, &md_len);
        EVP_MD_CTX_cleanup(&mdctx);
        return [NSData dataWithBytes:&md_value length:md_len];
}

static NSString *digestToHex(NSData *data, int digestLength)
{
        char hexDigest[HEXDIGEST_LENGTH(digestLength)];
        int i;
        unsigned char *buf = (unsigned char *)[data bytes];
        
        for (i = 0; i < digestLength; i++) {
		sprintf(hexDigest + i * 2, "%02x", buf[i]);
	}
        return [NSString stringWithCString:hexDigest length:HEXDIGEST_LENGTH(digestLength)];
}
