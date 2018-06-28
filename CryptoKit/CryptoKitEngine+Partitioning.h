//
//  CryptoKitEngine+Partitioning.h
//  CryptoKit
//
//  Created by Andreas Meingast on 16.05.18.
//  Copyright © 2018 Andreas Meingast. All rights reserved.
//

#import "CryptoKitEngine.h"

@interface CryptoKitEngine (Partitioning)

- (void)disassembleFromInputStreamInternal:(NSInputStream *)inputStream
                         partitionStrategy:(CKPartitionStrategy)partitionStrategy
                                  password:(NSString *)password
                              chunkHandler:(CKChunkHandler)chunkHandler;
- (void)assembleToOutputStreamInternal:(NSOutputStream *)outputStream
                              password:(NSString *)password
                         chunkProvider:(CKChunkProvider)chunkProvider;

@end
