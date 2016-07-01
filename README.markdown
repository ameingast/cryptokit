# CryptoKit

[![Build Status](https://api.travis-ci.org/ameingast/CryptoKit.png)](https://travis-ci.org/ameingast/CryptoKit)

Welcome to *CryptoKit*, a framework making cryptography easier on macOS and iOS.

## Rationale 

Encryption and digest calculation using the core macOS/iOS frameworks is not trivial. 

CommonCrypto is notoriously low-level and inconvenient to use from Swift and Objective-C.

CryptoKit fixes this problem. It provides convenience methods and categories for various classes to make encryption 
and digest calculation easier.

It provides safe and easy-to-use methods for encryption/decryption based on AES and digest calculations for MD* and SHA*.

## How To Get Started

### Installation with CocoaPods

Integrating this framework with Cocoapods is straightforward.

Just declare this dependency in your Podfile:

```ruby
pod 'CryptoKit', :git => 'https://github.com/ameingast/cryptokit.git'
```

### API

CryptoKit extends the following classes:

* [NSData](CryptoKit/NSData+CryptoKit.h)
* [NSInputStream](CryptoKit/NSInputStream+CryptoKit.h)
* [NSStream](CryptoKit/NSStream+CryptoKit.h)
* [NSString](CryptoKit/NSString+CryptoKit.h)
* [NSURL](CryptoKit/NSURL+CryptoKit.h)

All (low-level) CommonCrypto functionality is executed through the [CryptoKitEngine](CryptoKit/CryptoKitEngine) 
module which provides convience functions for:

* stream-based encryption
* stream-based digest calculation

### Using the Framework

#### NSData Encryption

```objective-c 
#import <CryptoKit/CryptoKit.h>

- (void)encryptData
{   
    NSError *error;
    NSData *plainData = [NSData new]; // replace with real data
    NSData *encryptedData = [plainData encryptedDataWithPassword:@"secret" error:&error];
    if (encryptedData) {
        // deal with encrypted data
    } else {
        // error handling
    }
}

- (void)decryptData                                   
{   
    NSError *error;
    NSData *encryptedData = [NSData new]; // replace with real data
    NSData *plainData = [encryptedData decryptedDataWithPassword:@"secret" error:&error];
    if (plainData) {
        // deal with decrypted data data
    } else {
        // error handling
    }
}
```

#### NSStream Encryption

```objective-c 
#import <CryptoKit/CryptoKit.h>

- (void)encryptStream
{
    NSError *error;
    NSInputStream *inputStream = [NSInputStream new]; // replace with real data
    NSOutputStream *outputStream = [NSOutputStream new]; // replace with real data
    BOOL result = [NSStream encryptInputStream:inputStream toOutputStream:outputStream password:@"secret" error:&error];
    if (result) {
        // encrypted data written to outputStream
    } else {
        // error handling
    }
}

- (void)decryptStream
{
    NSError *error;
    NSInputStream *inputStream = [NSInputStream new]; // replace with real data
    NSOutputStream *outputStream = [NSOutputStream new]; // replace with real data
    BOOL result = [NSStream decryptInputStream:inputStream toOutputStream:outputStream password:@"secret" error:&error];
    if (result) {
        // decrypted data written to outputStream
    } else {
        // error handling
    }
}
```

#### NSURL Encryption

```objective-c 
#import <CryptoKit/CryptoKit.h>

- (void)encryptURL
{
    NSError *error;
    NSURL *sourceURL = [NSURL fileURLWithPath:@"plain"]; // replace with real data
    NSURL *targetURL = [NSURL fileURLWithPath:@"encrypted"]; // replace with real data
    BOOL result = [sourceURL encryptedURLWithPassword:CryptoKitPassword targetURL:targetURL error:&error];
    if (result) {
        // encrypted data written to targetURL
    } else {
        // error handling
    }
}

- (void)decryptURL
{
    NSError *error;
    NSURL *sourceURL = [NSURL fileURLWithPath:@"encrypted"]; // replace with real data
    NSURL *targetURL = [NSURL fileURLWithPath:@"plain"]; // replace with real data
    BOOL result = [sourceURL decryptedURLWithPassword:CryptoKitPassword targetURL:targetURL error:&error];
    if (result) {
        // decrypted data written to targetURL
    } else {
        // error handling
    }
}
```

#### NSData Digests

```objective-c 

#import <CryptoKit/CryptoKit.h>

- (void)calculateDigest
{
    NSData *data = [NSData new]; // replace with real data
    NSString *hashInHumanReadableForm = [data md5HexHash];
    // ...
}
```

#### NSString Digests

```objective-c 
#import <CryptoKit/CryptoKit.h>

- (void)calculateDigest
{
    NSString *string = @"Some string"; // replace with real data
    NSString *hashInHumanReadableForm = [string md5HexHash];
    // ...
}
```

#### NSSTream Digests

```objective-c 

#import <CryptoKit/CryptoKit.h>

- (void)calculateDigest
{
    NSError *error;
    NSInputStream *inputStream = [NSInputStream new]; // replace with real data
    NSString *hashInHumanReadableForm = [inputStream md5HexHash:&error];
    if (hashInHumanReadableForm) {
        // ...
    } else {
        // deal with error
    }
}
```

#### NSURL Digests

```objective-c 

#import <CryptoKit/CryptoKit.h>

- (void)calculateDigest
{
    NSError *error;
    NSURL *url = [NSURL new]; // replace with real data
    NSString *hashInHumanReadableForm = [url md5HexHash:&error];
    if (hashInHumanReadableForm) {
        // ...
    } else {
        // deal with error
    }
}
```

More code samples can be found in the [test suite](CryptoKitTests/CryptoKitTests.m).

## Contact and Contributions

Please submit bug reports and improvements through pull-requests or tickets on github.

This project uses conservative compiler settings and a clang-format profile. 

Please be sure that no compiler warnings occur before sending patches or pull requests upstream. 

Thank you!

## Copyright and Licensing

Copyright (c) 2016, Andreas Meingast <ameingast@gmail.com>.

The framework is published under a BSD style license. For more information,
please see the LICENSE file.

## History

CryptoKit was formerly known as CocoaCryptoHashing. It provided roughly the same functionality,
but was built on top of OpenSSL which is no longer used for iOS and macOS development.

The project was renamed when OpenSSL was switched out for CommonCrypto.
