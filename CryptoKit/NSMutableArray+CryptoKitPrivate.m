//
//  NSMutableArray+CryptoKitPrivate.m
//  CryptoKit
//
//  Created by Andreas Meingast on 20.06.18.
//  Copyright © 2018 Andreas Meingast. All rights reserved.
//

#import "NSMutableArray+CryptoKitPrivate.h"

@implementation NSMutableArray (CryptoKitPrivate)

- (void)sortByComparingLastPathComponent
{
    [self sortUsingComparator:^NSComparisonResult(NSURL *lhs, NSURL *rhs) {
        NSString *lhsLastPathComponent = [lhs lastPathComponent];
        NSString *rhsLastPathComponent = [rhs lastPathComponent];
        if (!lhsLastPathComponent && !rhsLastPathComponent) {
            return NSOrderedSame;
        } else if (!lhsLastPathComponent) {
            return NSOrderedAscending;
        } else if (!rhsLastPathComponent) {
            return NSOrderedDescending;
        } else {
            return [lhsLastPathComponent localizedCaseInsensitiveCompare:rhsLastPathComponent];
        }
    }];
}

@end
