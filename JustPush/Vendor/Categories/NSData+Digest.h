//
//  NSData+MD5Digest.h
//  NSData+MD5Digest
//
//  Created by Francis Chong on 12年6月5日.
//

#import <Foundation/Foundation.h>

@interface NSData (Digest)

+ (NSData *)SHA1Digest:(NSData *)input;
- (NSData *) SHA1Digest;

+ (NSString *) SHA1HexDigest:(NSData *)input;
- (NSString *) SHA1HexDigest;

+(NSData *)MD5Digest:(NSData *)input;
-(NSData *)MD5Digest;

+(NSString *)MD5HexDigest:(NSData *)input;
-(NSString *)MD5HexDigest;

@end
