# CryptoKit

[![Build Status](https://api.travis-ci.org/ameingast/cryptokit.png)](https://travis-ci.org/ameingast/CryptoKit)

Welcome to *CryptoKit*, a framework making cryptography easier and safer on macOS and iOS.

## Rationale 

CryptoKit is an open source cryptographic framework designed to make cryptography operations on macOS and iOS easier
and safer.

Encryption and digest calculation using the core macOS/iOS frameworks is everything but trivial. CommonCrypto is 
notoriously low-level, inconvenient to use from Swift and Objective-C and its error handling is ambiguous.

Cryptography is easy to get wrong. Chosing the correct cipher, composing cryptographic operations in a correct manner 
and avoiding low-level C language pitfalls is hard.  

In order to fix this problem, this framework provides convenience methods and categories for various CoreFoundation 
classes to make encryption and digest calculation safer, less error-prone and easier by applying _good_, _safe_ and
_effective_ algorithms by default.

Some key design considerations of CryptoKit are:

* API simplicity
* Safe by default
* Automatic initialization vector generation
* Key/password rotation
* Encrypted data integrity and versioning
* Unambiguous errors
* First level support in Objective-C and Swift
* Constant memory space usage where possible 

CryptoKit does not intend to replace CommonCrypto or OpenSSL. It is merely a simpler user interface to a subset of
CommonCryptos operation set.

## Implementation Considerations

CryptoKit makes heavy use of data streams internally. This guarantees that all crypto and digest operations run
in constant memory space when using the stream based APIs. 

Encryption and decryption rely on a custom data format providing means to ensure data integrity.

## How To Get Started

### Requirements

CryptoKit requires either iOS 8.0 or macOS 10.6.

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

All (low-level) CommonCrypto functionality is executed through the [CryptoKitEngine](CryptoKit/CryptoKitEngine.h) 
class which provides convience functions for stream-based encryption and stream-based digest calculation.

### Using the Framework

#### NSData Encryption

```objective-c 
#import <CryptoKit/CryptoKit.h>

- (void)encryptData
{   
    NSError *error = nil;
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
    NSError *error = nil;
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
    NSError *error = nil;
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
    NSError *error = nil;
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
    NSError *error = nil;
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
    NSError *error = nil;
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

#### NSStream Digests

```objective-c 

#import <CryptoKit/CryptoKit.h>

- (void)calculateDigest
{
    NSError *error = nil;
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
    NSError *error = nil;
    NSURL *url = [NSURL new]; // replace with real data
    NSString *hashInHumanReadableForm = [url md5HexHash:&error];
    if (hashInHumanReadableForm) {
        // ...
    } else {
        // deal with error
    }
}
```

More code samples can be found in the [test suite](CryptoKitTests).

## Encryption Format

The encryption format is designed with several goals in mind:

* security
* authenticity
* backwards compatibility

### Layout

The data layout of the encrypted binary looks as follows:

| From   | To     | Size    | Content                      |
|--------|--------|---------|------------------------------|
| 0      | 3      | 4B      | Magic Number (Plain)         | 
| 4      | 7      | 4B      | Version (Plain)              | 
| 8      | 23     | 16B     | IV (Plain)                   | 
| 24     | 87     | 64B     | Salt (Plain)                 | 
| 88     | 151    | 64B     | IV + Salt Checksum (Plain)   | 
| 152    | 255    | 104B    | Reserved                     | 
| 256    | EOF-80 | VARYING | Payload (Encrypted)          | 
| EOF-79 | EOF    | 80B     | Payload Checksum (Encrypted) | 


### Semantics

#### Magic Number

A 4 byte magic number identifying the encrypted binary content. 32bit integer. Always the same.

#### Version

A 4 byte version number used to check for compatibility. 32bit integer. Value can change in later releases.

#### Initialization Vector

A 16 byte initialization vector that is used for encryption/decryption. Binary data.

#### Salt

A 64 byte salt value that is used for encryption/decryption. Binary data. 

#### Checksum of Initialization Vector + Salt

A 64 byte SHA512 checksum of the initialization vector + salt used for sanity checking the header. Binary data.

#### Padding

A 104 byte padding reserved for future use. Binary data. Offset can change in later releases.

#### Payload

A dynamically sized payload. Binary data. 

#### Payload Checksum

An 80 byte trailer containing an encrypted checksum of the payload. Binary data. Offset depending on length of 
encrypted payload.

## Contact and Contributions

Please submit bug reports and improvements through pull-requests or tickets on Github.

This project uses conservative compiler settings and a clang-format profile. 

Please be sure that no compiler warnings occur before sending patches or pull requests upstream. 

Thank you!

## Copyright and Licensing

Copyright (c) 2016, Andreas Meingast <ameingast@gmail.com>.

The framework is published under a BSD style license. For more information, please see the LICENSE file.

## History

CryptoKit was formerly known as CocoaCryptoHashing. It provided roughly the same functionality,
but was built on top of OpenSSL which is no longer used for iOS and macOS development.

The project was renamed and re-implemented from scratch when OpenSSL was switched out for CommonCrypto.
