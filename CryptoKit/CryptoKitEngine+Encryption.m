//
//  CryptoKitEngine+Encryption.m
//  CryptoKit
//
//  Created by Andreas Meingast on 05/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>


#import "CryptoKitTypes.h"
#import "CryptoKitEngine+Encryption.h"
#import "CryptoKitEngine+Keys.h"
#import "CryptoKitMessageHeader.h"
#import "CryptoKitMessagePayload.h"
#import "CryptoKitMessageTrailer.h"
#import "NSStream+CryptoKitPrivate.h"

const int32_t CryptoKitRecryptionBufferSize = 2048;

@implementation CryptoKitEngine (Encryption)

#pragma mark - Encryption

- (void)encryptStreamInternal:(NSInputStream *)inputStream
                 outputStream:(NSOutputStream *)outputStream
                     password:(NSString *)password
{
    NSAssert(inputStream, @"InputStream must not be nil");
    NSAssert(outputStream, @"OutputStream must not be nil");
    NSAssert(password, @"Password must not be nil");
    NSMutableData *key = nil;
    @try {
        CryptoKitMessageHeader *header = [CryptoKitMessageHeader new];
        [header writeToOutputStream:outputStream];
        key = [self generateKey:password
                           salt:header.salt];
        CryptoKitMessagePayload *payload = [CryptoKitMessagePayload new];
        [payload encryptDataFromInputStream:inputStream
                               outputStream:outputStream
                   withInitializationVector:header.initializationVector
                                    withKey:key];
        CryptoKitMessageTrailer *trailer = [CryptoKitMessageTrailer new];
        [trailer encryptPayloadDigestAndWriteToOutputStream:outputStream
                                       initializationVector:header.initializationVector
                                                        key:key
                                             digestChecksum:payload.payloadDigest];
    } @finally {
        if (key) {
            [self eraseKey:key];
        }
    }
}

- (void)decryptStreamInternal:(NSInputStream *)inputStream
                 outputStream:(NSOutputStream *)outputStream
                     password:(NSString *)password
{
    NSAssert(inputStream, @"InputStream must not be nil");
    NSAssert(outputStream, @"OutputStream must not be nil");
    NSAssert(password, @"Password must not be nil");
    NSMutableData *key = nil;
    @try {
        CryptoKitMessageHeader *header = [[CryptoKitMessageHeader alloc] initWithContentsFromInputStream:inputStream];
        key = [self generateKey:password
                           salt:header.salt];
        CryptoKitMessagePayload *payload = [[CryptoKitMessagePayload alloc] init];
        NSData *encryptedPayloadDigestFromStream = [payload decryptDataFromInputStream:inputStream
                                                                          outputStream:outputStream
                                                              withInitializationVector:header.initializationVector
                                                                               withKey:key];
        CryptoKitMessageTrailer *trailer = [CryptoKitMessageTrailer new];
        [trailer decryptPayloadDigestAndVerify:encryptedPayloadDigestFromStream
                          initializationVector:header.initializationVector
                                           key:key
                                expectedDigest:payload.payloadDigest];
    } @finally {
        if (key) {
            [self eraseKey:key];
        }
    }
}

- (void)recryptStreamInternal:(NSInputStream *)inputStream
                 outputStream:(NSOutputStream *)outputStream
                 withPassword:(NSString *)password
                  newPassword:(NSString *)newPassword
{
    NSInputStream *recryptInputStream = nil;
    NSOutputStream *recryptOutputStream = nil;
    NSException __block *exception = nil;
    [NSStream createBoundInputStream:&recryptInputStream
                        outputStream:&recryptOutputStream
                          bufferSize:CryptoKitRecryptionBufferSize];
    [recryptInputStream open];
    [recryptOutputStream open];
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
      @try {
          [self decryptStreamInternal:inputStream
                         outputStream:recryptOutputStream
                             password:password];
      } @catch (NSException *localException) {
          @synchronized(self)
          {
              if (!exception) {
                  exception = localException;
              }
          }
      } @finally {
          [recryptOutputStream close];
      }
    });
    dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
      @try {
          [self encryptStreamInternal:recryptInputStream
                         outputStream:outputStream
                             password:newPassword];
      } @catch (NSException *localException) {
          @synchronized(self)
          {
              if (!exception) {
                  exception = localException;
              }
          }
      } @finally {
          [recryptInputStream close];
      }
    });
    dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER);
    if (exception) {
        @throw exception;
    }
}

#pragma mark - Helpers

- (void)eraseKey:(NSMutableData *)data
{
    NSRange dataRange = NSMakeRange(0, [data length]);
    [data resetBytesInRange:dataRange];
}

@end
