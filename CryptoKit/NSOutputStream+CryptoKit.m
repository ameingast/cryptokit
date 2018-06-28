//
//  NSOutputStream+CryptoKit.m
//  CryptoKit
//
//  Created by Andreas Meingast on 18.05.18.
//  Copyright © 2018 Andreas Meingast. All rights reserved.
//

#import "NSOutputStream+CryptoKit.h"
#import "CryptoKitEngine.h"

@implementation NSOutputStream (CryptoKit)

- (BOOL)assembleWithPassword:(NSString *)password
               chunkProvider:(CKChunkProvider)chunkProvider
                       error:(NSError *__autoreleasing *)error
{
    return [[CryptoKitEngine sharedInstance] assembleToOutputStream:self
                                                           password:password
                                                      chunkProvider:chunkProvider
                                                              error:error];
}

@end
