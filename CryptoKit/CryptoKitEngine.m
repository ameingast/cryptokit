//
//  CryptoKitEngine.m
//  CryptoKit
//
//  Created by Andreas Meingast on 09/06/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import <CryptoKit/CryptoKitErrors.h>

#import "CryptoKitEngine+Digests.h"
#import "CryptoKitEngine+Encryption.h"
#import "CryptoKitEngine+Keys.h"
#import "CryptoKitEngine.h"
#import "CryptoKitMessageHeader.h"
#import "CryptoKitTypes.h"

@interface CryptoKitEngine ()

- (NSError *)translateException:(NSException *)exception;

@end

@implementation CryptoKitEngine

+ (instancetype)sharedInstance
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
            *error = [self translateException:exception];
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
            *error = [self translateException:exception];
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
            *error = [self translateException:exception];
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
            *error = [self translateException:exception];
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
            *error = [self translateException:exception];
        }
        return NO;
    }
}

#pragma mark - Helpers

- (NSError *)translateException:(NSException *)exception
{
    NSAssert(exception, @"Exception must not be nil");
    NSString *reason = [exception reason];
    NSDictionary *userInfo = [exception userInfo];
    NSNumber *errorCode = userInfo[@"errorCode"];
    NSMutableDictionary *errorUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    errorUserInfo[NSLocalizedFailureReasonErrorKey] = reason;
    NSError *error = [NSError errorWithDomain:CryptoKitErrorDomain
                                         code:[errorCode integerValue]
                                     userInfo:errorUserInfo];

    return error;
}

@end
