//
//  NSOutputStream+CryptoKit.h
//  CryptoKit
//
//  Created by Andreas Meingast on 18.05.18.
//  Copyright © 2018 Andreas Meingast. All rights reserved.
//

#import <CryptoKit/CryptoKitTypes.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSOutputStream (CryptoKit)

#pragma mark - Partitioning

/**
 * Decrypts and assembles all provided chunks using the provided password. Writes to this NSOutputStream instance.
 *
 * Assembly is stopped when chunkProvider returns nil.
 *
 * @warning     This method will block the current thread until chunkProvider returns nil or an error has occured.
 */
- (BOOL)assembleWithPassword:(NSString *)password
               chunkProvider:(CKChunkProvider)chunkProvider
                       error:(NSError *__nullable *)error;

@end

NS_ASSUME_NONNULL_END
