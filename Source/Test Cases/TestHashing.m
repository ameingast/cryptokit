/*
 * TestHashing.m
 * CocoaCryptoHashing
 * 
 * Copyright (c) 2004-2005 Denis Defreyne
 *               2006 Andreas Meingast
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

#import "TestHashing.h"
#import "CocoaCryptoHashing.h"

@implementation TestHashing

- (void)testMD2
{
        unsigned int i;
	NSString *MD2TestStrings[] = {
		@"abc",
		@"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
		@"a",
		@"0123456701234567012345670123456701234567012345670123456701234567"
	};
	NSString *MD2TestStringResults[] = {
		@"da853b0d3f88d99b30283a69e6ded6bb",
		@"0dff6b398ad5a62ac8d97566b80c3a7f",
		@"32ec01ec4a6dac72c0ab96fb34c0b5d1",
		@"b397b0941b13002609e2c6e1e57c5749"
	};
	
	for (i = 0; i < sizeof(MD2TestStrings) / sizeof(NSString *); i++) {
		STAssertEqualObjects([MD2TestStrings[i] md2HexHash],
                                     MD2TestStringResults[i],
                                     @"(calculated) %s != (present) %s\n",
                                     [MD2TestStrings[i] md2HexHash],
                                     MD2TestStringResults[i]);
        }
        STAssertEqualObjects(@"548ef5c75874722e84ffb88ce2cb523a", [[NSFileHandle fileHandleForReadingAtPath:@"./Resources/blob"] md2HexHash], @"");
}

- (void)testMD4
{
	unsigned int i;
	NSString *MD4TestStrings[] = {
		@"jaksdjhflkajsdhflkjashdflkjahsdflkjhkdls<jf",
		@"asdufgzaiuszgdy<nxcvb1987234hjsesdfasdf",
		@"sd98fg9ausdgkjnbmyxbcvjhlagsaiue6ljahlkjh"
	};
	NSString *MD4TestStringResults[] = {
		@"39392c93760839fd42d4776fdadefcdb",
		@"852d4667f555b16b3cb86a9d332cba05",
		@"79b62b45ba66a9ef5f5a0cc3d87c3eaf"
	};
	
	for (i = 0; i < sizeof(MD4TestStrings) / sizeof(NSString *); i++) {
		STAssertEqualObjects([MD4TestStrings[i] md4HexHash],
				     MD4TestStringResults[i],
				     @"(calculated) %s != (present) %s\n",
				     [MD4TestStrings[i] md4HexHash],
				     MD4TestStringResults[i]);
	}
        
        STAssertEqualObjects(@"da38fb7ee35d516ac2075ce29b315fef", [[NSFileHandle fileHandleForReadingAtPath:@"./Resources/blob"] md4HexHash], @"");
}

- (void)testMD5
{	
	unsigned int i;
	NSString *MD5TestStrings[] = {
		@"",
		@"a",
		@"abc",
		@"message digest",
		@"abcdefghijklmnopqrstuvwxyz",
		@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
		@"12345678901234567890123456789012345678901234567890123456789012345678901234567890"
	};
	NSString *MD5TestStringResults[] = {
		@"d41d8cd98f00b204e9800998ecf8427e",
		@"0cc175b9c0f1b6a831c399e269772661",
		@"900150983cd24fb0d6963f7d28e17f72",
		@"f96b697d7cb7938d525a2f31aaf161d0",
		@"c3fcd3d76192e4007dfb496cca67e13b",
		@"d174ab98d277d9f5a5611c2c9f419d9f",
		@"57edf4a22be3c955ac49da2e2107b67a"
	};
	
	for (i = 0; i < sizeof(MD5TestStrings) / sizeof(NSString *); i++) {
		STAssertEqualObjects([MD5TestStrings[i] md5HexHash],
				     MD5TestStringResults[i],
				     @"(calculated) %s != (present) %s\n",
				     [MD5TestStrings[i] md5HexHash],
				     MD5TestStringResults[i]);
	}
        STAssertEqualObjects(@"c544d826e31adaa52837f808c111292b", [[NSFileHandle fileHandleForReadingAtPath:@"./Resources/blob"] md5HexHash], @"");
}

- (void)testRIPEMD160
{
        unsigned int i;
	NSString *RIPEMD160TestStrings[] = {
		@"abc",
		@"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
		@"a",
		@"0123456701234567012345670123456701234567012345670123456701234567"
	};
	NSString *RIPEMD160TestStringResults[] = {
		@"8eb208f7e05d987a9b044a8e98c6b087f15a0bfc",
		@"12a053384a9c0c88e405a06c27dcf49ada62eb2b",
		@"0bdc9d2d256b3ee9daae347be6f4dc835a467ffe",
		@"975b50bd633bda52a1b5ef7e1feac183a3fbfdb4"
	};
	
	for (i = 0; i < sizeof(RIPEMD160TestStrings) / sizeof(NSString *); i++) {
		STAssertEqualObjects([RIPEMD160TestStrings[i] rmd160HexHash],
                                     RIPEMD160TestStringResults[i],
                                     @"(calculated) %s != (present) %s\n",
                                     [RIPEMD160TestStrings[i] rmd160HexHash],
                                     RIPEMD160TestStringResults[i]);
        }
        STAssertEqualObjects(@"8ed321d671598dc89a236edf688e39780ec46efd", [[NSFileHandle fileHandleForReadingAtPath:@"./Resources/blob"] rmd160HexHash], @"");
}

- (void)testSHA
{
        unsigned int i;
	NSString *SHATestStrings[] = {
		@"abc",
		@"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
		@"a",
		@"0123456701234567012345670123456701234567012345670123456701234567"
	};
	NSString *SHATestStringResults[] = {
		@"0164b8a914cd2a5e74c4f7ff082c4d97f1edf880",
		@"d2516ee1acfa5baf33dfc1c471e438449ef134c8",
		@"37f297772fae4cb1ba39b6cf9cf0381180bd62f2",
		@"63ef8e92a7a9fe9c2251ea28bfb40a280d5e0a4e"
	};
	
	for (i = 0; i < sizeof(SHATestStrings) / sizeof(NSString *); i++) {
		STAssertEqualObjects([SHATestStrings[i] shaHexHash],
                                     SHATestStringResults[i],
                                     @"(calculated) %s != (present) %s\n",
                                     [SHATestStrings[i] shaHexHash],
                                     SHATestStringResults[i]);
        }
        STAssertEqualObjects(@"94ea30a14f30ccacb0916311786eb0190e1426e2", [[NSFileHandle fileHandleForReadingAtPath:@"./Resources/blob"] shaHexHash], @"");
}

- (void)testSHA1
{
	unsigned int i;
	NSString *SHA1TestStrings[] = {
		@"abc",
		@"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
		@"a",
		@"0123456701234567012345670123456701234567012345670123456701234567"
	};
	NSString *SHA1TestStringResults[] = {
		@"a9993e364706816aba3e25717850c26c9cd0d89d",
		@"84983e441c3bd26ebaae4aa1f95129e5e54670f1",
		@"86f7e437faa5a7fce15d1ddcb9eaeaea377667b8",
		@"e0c094e867ef46c350ef54a7f59dd60bed92ae83"
	};
	
	for (i = 0; i < sizeof(SHA1TestStrings) / sizeof(NSString *); i++) {
		STAssertEqualObjects([SHA1TestStrings[i] sha1HexHash],
			       SHA1TestStringResults[i],
			       @"(calculated) %s != (present) %s\n",
			       [SHA1TestStrings[i] sha1HexHash],
			       SHA1TestStringResults[i]);
        }
        STAssertEqualObjects(@"87031dfcc73028180a6a6b2a0e0c19efb97ef78c", [[NSFileHandle fileHandleForReadingAtPath:@"./Resources/blob"] sha1HexHash], @"");
}

@end
