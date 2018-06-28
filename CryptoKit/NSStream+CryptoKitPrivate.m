//
//  NSStream+CryptoKitPrivate.m
//  CryptoKit
//
//  Created by Andreas Meingast on 15/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import "NSStream+CryptoKitPrivate.h"

@implementation NSStream (CryptoKitPrivate)

+ (void)createBoundInputStream:(NSInputStream *__autoreleasing *)inputStream
                  outputStream:(NSOutputStream *__autoreleasing *)outputStream
                    bufferSize:(int32_t)bufferSize
{
    NSAssert(inputStream, @"InputStream must not be nil");
    NSAssert(outputStream, @"OutputStream must not be nil");
    CFReadStreamRef readStream = nil;
    CFWriteStreamRef writeStream = nil;
    CFStreamCreateBoundPair(kCFAllocatorDefault, &readStream, &writeStream, bufferSize);
    *inputStream = CFBridgingRelease(readStream);
    *outputStream = CFBridgingRelease(writeStream);
}

- (id)withOpenStream:(id (^)(void))callback
{
    NSStreamStatus initialStatus = [self streamStatus];
    @try {
        if ([self streamStatus] == NSStreamStatusNotOpen) {
            [self open];
        }
        id result = callback();
        return result;
    } @finally {
        if (initialStatus == NSStreamStatusNotOpen) {
            [self close];
        }
    }
}

@end
