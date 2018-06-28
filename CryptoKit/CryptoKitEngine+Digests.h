//
//  CryptoKitEngine+Digests.h
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import "CryptoKitEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CryptoKitEngine (Digests)

- (NSData *)calculateDigestInternal:(NSInputStream *)inputStream
                         digestType:(CryptoKitDigestType)digestType;
- (NSString *)digestToHumanReadableRepresentationInternal:(NSData *)data
                                               digestType:(CryptoKitDigestType)digestType;
- (CKDigestBatchResult *)calculateDigestsInternal:(NSInputStream *)inputStream;

@end

NS_ASSUME_NONNULL_END
