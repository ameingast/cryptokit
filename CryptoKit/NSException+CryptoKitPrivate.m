//
//  NSException+CryptoKitPrivate.m
//  CryptoKit
//
//  Created by Andreas Meingast on 26.05.18.
//  Copyright © 2018 Andreas Meingast. All rights reserved.
//

#import "NSException+CryptoKitPrivate.h"
#import "CryptoKitTypes.h"

@implementation NSException (CryptoKitPrivate)

- (NSError *)asError
{
    NSNumber *errorCode = [self userInfo][@"errorCode"];
    NSMutableDictionary *errorUserInfo = [self userInfo]
        ? [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[self userInfo]]
        : [NSMutableDictionary new];
    errorUserInfo[NSLocalizedFailureReasonErrorKey] = [self reason];
    NSError *error = [NSError errorWithDomain:CryptoKitErrorDomain
                                         code:[errorCode integerValue]
                                     userInfo:errorUserInfo];

    return error;
}

@end
