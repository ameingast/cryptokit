//
//  NSOutputStream+CryptoKitPrivate.m
//  CryptoKit
//
//  Created by Andreas Meingast on 15/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import "CryptoKitTypes.h"
#import "NSOutputStream+CryptoKitPrivate.h"

@implementation NSOutputStream (CryptoKitPrivate)

- (void)blockingWriteData:(NSData *)data
{
    NSAssert(data, @"Data must not be nil");
    NSUInteger bytesToWrite = [data length];
    NSUInteger totalBytesWritten = 0;
    while (totalBytesWritten < bytesToWrite) {
        NSData *dataToWrite = [data subdataWithRange:NSMakeRange(totalBytesWritten, bytesToWrite - totalBytesWritten)];
        NSInteger bytesWritten = [self write:[dataToWrite bytes]
                                   maxLength:bytesToWrite - totalBytesWritten];
        if (bytesWritten < 0) {
            @throw [NSException exceptionWithName:CryptoKitErrorDomain
                                           reason:@"Write operation on output-stream failed"
                                         userInfo:@{ @"errorCode": @(CryptoKitIOError) }];
        } else if (bytesWritten == 0) {
            while (![self hasSpaceAvailable]) {
                // TODO: replace with event based solution
                [NSThread sleepForTimeInterval:0.1];
            }
        } else {
            totalBytesWritten += (NSUInteger)bytesWritten;
        }
    }
}

@end
