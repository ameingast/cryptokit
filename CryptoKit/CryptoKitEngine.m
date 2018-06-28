//
//  CryptoKitEngine.m
//  CryptoKit
//
//  Created by Andreas Meingast on 09/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>

#import "CryptoKitEngine+Digests.h"
#import "CryptoKitEngine+Encryption.h"
#import "CryptoKitEngine+Keys.h"
#import "CryptoKitEngine+Partitioning.h"
#import "CryptoKitEngine.h"
#import "CryptoKitMessageHeader.h"
#import "CryptoKitTypes.h"
#import "NSException+CryptoKitPrivate.h"

@implementation CryptoKitEngine

+ (CryptoKitEngine *)sharedInstance
{
    static CryptoKitEngine *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CryptoKitEngine new];
    });
    return instance;
}

#pragma mark - Digests

- (NSData *)calculateDigest:(NSInputStream *)inputStream
                 digestType:(CryptoKitDigestType)digestType
                      error:(NSError *__autoreleasing *)error
{
    @try {
        NSData *result = [self calculateDigestInternal:inputStream
                                            digestType:digestType];
        return result;
    } @catch (NSException *exception) {
        if (error) {
            *error = [exception asError];
        }
        return nil;
    }
}

- (CKDigestBatchResult *)calculateDigests:(NSInputStream *)inputStream
                                    error:(NSError *__autoreleasing *)error
{
    @try {
        CKDigestBatchResult *result = [self calculateDigestsInternal:inputStream];
        return result;
    } @catch (NSException *exception) {
        if (error) {
            *error = [exception asError];
        }
        return nil;
    }
}

- (NSString *)digestToHumanReadableRepresentation:(NSData *)data
                                       digestType:(CryptoKitDigestType)digestType
                                            error:(NSError *__autoreleasing *)error
{
    @try {
        NSString *result = [self digestToHumanReadableRepresentationInternal:data
                                                                  digestType:digestType];
        return result;
    } @catch (NSException *exception) {
        if (error) {
            *error = [exception asError];
        }
        return nil;
    }
}

#pragma mark - Encryption

- (BOOL)encryptStream:(NSInputStream *)inputStream
         outputStream:(NSOutputStream *)outputStream
             password:(NSString *)password
                error:(NSError *__autoreleasing *)error
{
    @try {
        [self encryptStreamInternal:inputStream
                       outputStream:outputStream
                           password:password];
        return YES;
    } @catch (NSException *exception) {
        if (error) {
            *error = [exception asError];
        }
        return NO;
    }
}

- (BOOL)decryptStream:(NSInputStream *)inputStream
         outputStream:(NSOutputStream *)outputStream
             password:(NSString *)password
                error:(NSError *__autoreleasing *)error
{
    @try {
        [self decryptStreamInternal:inputStream
                       outputStream:outputStream
                           password:password];
        return YES;
    } @catch (NSException *exception) {
        if (error) {
            *error = [exception asError];
        }
        return NO;
    }
}

- (BOOL)recryptInputStream:(NSInputStream *)inputStream
            toOutputStream:(NSOutputStream *)outputStream
                  password:(NSString *)password
               newPassword:(NSString *)newPassword
                     error:(NSError *__autoreleasing *)error
{
    @try {
        [self recryptStreamInternal:inputStream
                       outputStream:outputStream
                       withPassword:password
                        newPassword:newPassword];
        return YES;
    } @catch (NSException *exception) {
        if (error) {
            *error = [exception asError];
        }
        return NO;
    }
}

#pragma mark - Partitioning

- (BOOL)disassembleFromInputStream:(NSInputStream *)inputStream
                 partitionStrategy:(CKPartitionStrategy)partitionStrategy
                          password:(NSString *)password
                      chunkHandler:(CKChunkHandler)chunkHandler
                             error:(NSError *__autoreleasing *)error
{
    BOOL __block success = YES;
    @try {
        [self disassembleFromInputStreamInternal:inputStream
                               partitionStrategy:partitionStrategy
                                        password:password
                                    chunkHandler:chunkHandler];
    } @catch (NSException *exception) {
        if (error) {
            *error = [exception asError];
        }
        success = NO;
    }
    return success;
}

- (BOOL)assembleToOutputStream:(NSOutputStream *)outputStream
                      password:(NSString *)password
                 chunkProvider:(CKChunkProvider)chunkProvider
                         error:(NSError *__autoreleasing *)error
{
    @try {
        [self assembleToOutputStreamInternal:outputStream
                                    password:password
                               chunkProvider:chunkProvider];
        return YES;
    } @catch (NSException *exception) {
        if (error) {
            *error = [exception asError];
        }
        return NO;
    }
}

@end
