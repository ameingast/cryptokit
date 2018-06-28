//
//  CryptoKitEngine+Partitioning.m
//  CryptoKit
//
//  Created by Andreas Meingast on 16.05.18.
//  Copyright © 2018 Andreas Meingast. All rights reserved.
//

#import "CryptoKitEngine+Partitioning.h"
#import "CryptoKitEngine+Encryption.h"
#import "NSStream+CryptoKitPrivate.h"
#import "NSInputStream+CryptoKitPrivate.h"
#import "NSOutputStream+CryptoKitPrivate.h"

@implementation CryptoKitEngine (Partitioning)

- (void)disassembleFromInputStreamInternal:(NSInputStream *)inputStream
                         partitionStrategy:(CKPartitionStrategy)partitionStrategy
                                  password:(NSString *)password
                              chunkHandler:(CKChunkHandler)chunkHandler
{
    NSAssert(inputStream, @"InputStream must not be nil");
    NSAssert(password, @"Password must not be nil");
    NSAssert(chunkHandler, @"ChunkHandler must not be nil");
    for (;;) {
        NSMutableData *buffer = NSMutableDataForPartitionStrategy(partitionStrategy);
        NSInteger bytesRead = [inputStream read:[buffer mutableBytes]
                                      maxLength:[buffer length]];
        if (bytesRead < 0) {
            @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                           reason:@"Read operation on input-stream failed"
                                         userInfo:@{ @"errorCode": @(CryptoKitIOError) }];
        } else if (bytesRead == 0) {
            break;
        } else {
            NSData *filledBuffer = [NSData dataWithBytes:[buffer bytes]
                                                  length:(NSUInteger)bytesRead];
            NSInputStream *dataInputStream = [NSInputStream inputStreamWithData:filledBuffer];
            NSOutputStream *dataOutputStream = [NSOutputStream outputStreamToMemory];
            [dataInputStream withOpenStream:^id {
                [dataOutputStream withOpenStream:^id {
                    [self encryptStreamInternal:dataInputStream
                                   outputStream:dataOutputStream
                                       password:password];
                    NSData *chunk = [dataOutputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
                    if (!chunk) {
                        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                                       reason:@"Write operation on output-stream failed"
                                                     userInfo:@{ @"errorCode": @(CryptoKitIOError) }];
                    }
                    BOOL handlerResult = chunkHandler(chunk);
                    if (!handlerResult) {
                        @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                                       reason:@"Chunk-Handler operation failed"
                                                     userInfo:@{ @"errorCode": @(CryptoKitIOError) }];
                    }
                    return nil;
                }];
                return nil;
            }];
        }
    }
}

- (void)assembleToOutputStreamInternal:(NSOutputStream *)outputStream
                              password:(NSString *)password
                         chunkProvider:(CKChunkProvider)chunkProvider
{
    NSAssert(outputStream, @"OutputStream must not be nil");
    NSAssert(password, @"Password must not be nil");
    NSAssert(chunkProvider, @"ChunkProvider must not be nil");
    for (;;) {
        NSData *partitionChunk = chunkProvider();
        if (!partitionChunk) {
            break;
        }
        NSInputStream *dataInputStream = [NSInputStream inputStreamWithData:partitionChunk];
        NSOutputStream *dataOutputStream = [NSOutputStream outputStreamToMemory];
        [dataInputStream withOpenStream:^id {
            [dataOutputStream withOpenStream:^id {
                [self decryptStreamInternal:dataInputStream
                               outputStream:dataOutputStream
                                   password:password];
                NSData *data = [dataOutputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
                if (!data) {
                    @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                                   reason:@"Write operation on output-stream failed"
                                                 userInfo:@{ @"errorCode": @(CryptoKitIOError) }];
                }
                [outputStream blockingWriteData:data];
                return nil;
            }];
            return nil;
        }];
    }
}

@end

