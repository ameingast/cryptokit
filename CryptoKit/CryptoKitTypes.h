//
//  CryptoKitTypes.h
//  CryptoKit
//
//  Created by Andreas Meingast on 03/07/16.
//  Copyright © 2016 Andreas Meingast. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 * The error domain/description of all errors and exeptions created by CryptoKit.
 */
extern NSString *const CryptoKitErrorDomain;

/**
 * A function type for handling encrypted, partitioned data.
 */
typedef BOOL (^CKChunkHandler)(NSData *chunk);

/**
 * A function type that provides encrypted, partitioned data for de-partitioning and decryption.
 */
typedef NSData * __nullable (^CKChunkProvider)(void);

/**
 * A CKChunkHandler helper function that persists all provided chunks into the given directory
 * as separate files. The filename starts with CK-
 */
__nullable CKChunkHandler CKChunkHandlerForFilesInDirectory(NSURL *directory, NSError *__nullable *error);

/**
 * A CKChunkProvider that reads all files that match CK-* in the given directory.
 */
__nullable CKChunkProvider CKChunkProviderForFilesInDirectory(NSURL *directory, NSError *__nullable *error);

/**
 * Unique identifiers for digests used in digest batch-operations.
 */
typedef NS_ENUM(NSUInteger, CryptoKitDigestType) {
    CryptoKitDigestTypeError = 0,
    CryptoKitDigestTypeMD2 = 1,
    CryptoKitDigestTypeMD4 = 2,
    CryptoKitDigestTypeMD5 = 3,
    CryptoKitDigestTypeSHA1 = 4,
    CryptoKitDigestTypeSHA224 = 5,
    CryptoKitDigestTypeSHA384 = 6,
    CryptoKitDigestTypeSHA512 = 7
};

/**
 * The error codes used in propagated NSErrors.
 */
typedef NS_ENUM(NSInteger, CryptoKitErrorCode) {
    /// Used for internal, low level errors.
    CryptoKitInternalError = 0,
    /// There was an IO error during stream processing.
    CryptoKitIOError = 1,
    /// The key could not be generated.
    CryptoKitKeyError = 2,
    /// Data provided for decryption does not match on magic byte header.
    CryptoKitMagicNumberMismatch = 3,
    /// Data provided for decryption has incompatible version.
    CryptoKitVersionMismatch = 4,
    /// Data provided for decryption has an invalid header checksum.
    CryptoKitMessageHeaderChecksumMismatch = 5,
    /// Data provided for decryption has an invalid body checksum (caused by data corruption or an invalid password).
    CryptoKitPayloadChecksumMismatch = 6
};

/**
 * Defines the partition strategy used for generating file chunks.
 *
 * * CKPartitionStrategyFixed - All partitions are equally sized
 * * CKPartitionStrategyRandom - The size of each partition is random
 */
typedef NS_ENUM(NSInteger, CKPartitionStrategy) {
    CKPartitionStrategyFixed,
    CKPartitionStrategyRandom
};

/**
 * Calculates the digest byte length of the provided digest-type.
 */
NSUInteger CryptoKitDigestTypeSize(CryptoKitDigestType type);

/**
 * Converts the provided cc-error number into a human-readable format.
 */
NSString *NSStringFromCCStatus(int32_t status);

/**
 * Creates a mutable data buffer for the provided CKPartitionStrategy.
 */
NSMutableData * __nullable NSMutableDataForPartitionStrategy(CKPartitionStrategy partitionStrategy);

/**
 * Contains the result of a digest-batch operation.
 */
@interface CKDigestBatchResult : NSObject

@property (nonnull, readonly, nonatomic) NSData *md2Digest;
@property (nonnull, readonly, nonatomic) NSData *md4Digest;
@property (nonnull, readonly, nonatomic) NSData *md5Digest;
@property (nonnull, readonly, nonatomic) NSData *sha1Digest;
@property (nonnull, readonly, nonatomic) NSData *sha224Digest;
@property (nonnull, readonly, nonatomic) NSData *sha384Digest;
@property (nonnull, readonly, nonatomic) NSData *sha512Digest;
@property (nonnull, readonly, nonatomic) NSString *md2HexDigest;
@property (nonnull, readonly, nonatomic) NSString *md4HexDigest;
@property (nonnull, readonly, nonatomic) NSString *md5HexDigest;
@property (nonnull, readonly, nonatomic) NSString *sha1HexDigest;
@property (nonnull, readonly, nonatomic) NSString *sha224HexDigest;
@property (nonnull, readonly, nonatomic) NSString *sha384HexDigest;
@property (nonnull, readonly, nonatomic) NSString *sha512HexDigest;

- (CKDigestBatchResult *)initWithMd2Digest:(NSData *)md2Digest
                              md2HexDigest:(NSString *)md2HexDigest
                                 md4Digest:(NSData *)md4Digest
                              md4HexDigest:(NSString *)md4HexDigest
                                 md5Digest:(NSData *)md5Digest
                              md5HexDigest:(NSString *)md5HexDigest
                                sha1Digest:(NSData *)sha1Digest
                             sha1HexDigest:(NSString *)sha1HexDigest
                              sha224Digest:(NSData *)sha224Digest
                           sha224HexDigest:(NSString *)sha224HexDigest
                              sha384Digest:(NSData *)sha384Digest
                           sha384HexDigest:(NSString *)sha384HexDigest
                              sha512Digest:(NSData *)sha512Digest
                           sha512HexDigest:(NSString *)sha512HexDigest;

@end

NS_ASSUME_NONNULL_END
