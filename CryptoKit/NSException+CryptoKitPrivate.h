//
//  NSException+CryptoKitPrivate.h
//  CryptoKit
//
//  Created by Andreas Meingast on 26.05.18.
//  Copyright © 2018 Andreas Meingast. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSException (CryptoKitPrivate)

- (NSError *)asError;

@end

NS_ASSUME_NONNULL_END
