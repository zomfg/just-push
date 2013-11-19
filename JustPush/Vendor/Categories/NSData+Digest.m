//
//  NSData+MD5Digest.m
//  NSData+MD5Digest
//
//  Created by Francis Chong on 12年6月5日.
//

#import "NSData+Digest.h"
#import <CommonCrypto/CommonDigest.h>

typedef unsigned char (*digest_method)(const void *, CC_LONG, unsigned char *) ;

@implementation NSData (Digest)

+ (NSString *) hexDigest:(NSData *)input method:(digest_method)method length:(NSUInteger)length {
    unsigned char result[length];
    
    method(input.bytes, (CC_LONG)input.length, result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:length << 1];
    for (int i = 0; i < length; i++)
        [ret appendFormat:@"%02x",result[i]];
    return ret;
}

+ (NSData *) digest:(NSData *)input method:(digest_method)method length:(NSUInteger)length {
    unsigned char result[length];
    
    method(input.bytes, (CC_LONG)input.length, result);
    return [NSData dataWithBytes:result length:length];
}

#pragma mark - SHA1

+ (NSData *)SHA1Digest:(NSData *)input
{
    return [self digest:input method:(digest_method)&CC_SHA1 length:CC_SHA1_DIGEST_LENGTH];
}

- (NSData *) SHA1Digest
{
    return [[self class] SHA1Digest:self];
}


+ (NSString *) SHA1HexDigest:(NSData *)input {
    return [self hexDigest:input method:(digest_method)&CC_SHA1 length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *) SHA1HexDigest {
    return [[self class] SHA1HexDigest:self];
}

#pragma mark - MD5

+ (NSData *) MD5Digest:(NSData *)input {
    return [self digest:input method:(digest_method)&CC_MD5 length:CC_MD5_DIGEST_LENGTH];
}

- (NSData *) MD5Digest {
    return [[self class] MD5Digest:self];
}

+ (NSString *) MD5HexDigest:(NSData *)input {
    return [self hexDigest:input method:(digest_method)&CC_MD5 length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *) MD5HexDigest {
    return [[self class] MD5HexDigest:self];
}

@end
