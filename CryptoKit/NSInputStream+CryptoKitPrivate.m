//
//  NSInputStream+CryptoKitPrivate.m
//  CryptoKit
//
//  Created by Andreas Meingast on 15/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import "CryptoKitErrors.h"
#import "NSInputStream+CryptoKitPrivate.h"

@implementation NSInputStream (CryptoKitPrivate)

- (void)consumeDataIntoBuffer:(NSMutableData *)buffer
                     callback:(void (^)(NSUInteger bytesRead))callback
{
    NSAssert(buffer, @"buffer must not be nil");
    NSAssert(callback, @"Callback must not be nil");
    for (;;) {
        NSInteger bytesRead = [self read:[buffer mutableBytes]
                               maxLength:[buffer length]];
        if (bytesRead < 0) {
            @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                           reason:@"Read operation on input-stream failed"
                                         userInfo:@{ @"errorCode": @(CryptoKitIOError) }];
        } else if (bytesRead == 0) {
            break;
        } else {
            callback((NSUInteger)bytesRead);
        }
    }
}

- (NSData *)blockingReadDataOfLength:(NSUInteger)bytesToRead
{
    NSMutableData *data = [NSMutableData dataWithLength:bytesToRead];
    NSUInteger totalBytesRead = 0;
    while (totalBytesRead < bytesToRead) {
        NSMutableData *dataToRead = [NSMutableData dataWithLength:bytesToRead - totalBytesRead];
        NSInteger bytesRead = [self read:[dataToRead mutableBytes]
                               maxLength:bytesToRead - totalBytesRead];
        if (bytesRead < 0) {
            @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                           reason:@"Read operation on input-stream failed"
                                         userInfo:@{ @"errorCode": @(CryptoKitIOError) }];
        }
        [data replaceBytesInRange:NSMakeRange(totalBytesRead, (NSUInteger)bytesRead)
                        withBytes:[dataToRead bytes]];
        totalBytesRead += (NSUInteger)bytesRead;
        if (bytesRead == 0) {
            NSString *reason = [NSString stringWithFormat:@"End of stream reached with bytes consumed: %@, "
                                                           "bytes expected: %@",
                                                          @(totalBytesRead), @(bytesToRead)];
            @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                           reason:reason
                                         userInfo:@{ @"errorCode": @(CryptoKitIOError) }];
        }
    }
    return data;
}

@end
