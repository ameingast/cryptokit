/*
 * CocoaCryptoHashing.h
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

#import <Foundation/Foundation.h>

@interface NSString (CocoaCryptoHashing)

- (NSData *)md2Hash;
- (NSString *)md2HexHash;
- (NSData *)md4Hash;
- (NSString *)md4HexHash;
- (NSData *)md5Hash;
- (NSString *)md5HexHash;
- (NSData *)rmd160Hash;
- (NSString *)rmd160HexHash;
- (NSData *)shaHash;
- (NSString *)shaHexHash;
- (NSData *)sha1Hash;
- (NSString *)sha1HexHash;

@end

@interface NSData (CocoaCryptoHashing)

- (NSData *)md2Hash;
- (NSString *)md2HexHash;
- (NSData *)md4Hash;
- (NSString *)md4HexHash;
- (NSData *)md5Hash;
- (NSString *)md5HexHash;
- (NSData *)rmd160Hash;
- (NSString *)rmd160HexHash;
- (NSData *)shaHash;
- (NSString *)shaHexHash;
- (NSData *)sha1Hash;
- (NSString *)sha1HexHash;

@end

@interface NSFileHandle (CocoaCryptoHashing)

- (NSData *)md2Hash;
- (NSString *)md2HexHash;
- (NSData *)md4Hash;
- (NSString *)md4HexHash;
- (NSData *)md5Hash;
- (NSString *)md5HexHash;
- (NSData *)rmd160Hash;
- (NSString *)rmd160HexHash;
- (NSData *)shaHash;
- (NSString *)shaHexHash;
- (NSData *)sha1Hash;
- (NSString *)sha1HexHash;

@end
