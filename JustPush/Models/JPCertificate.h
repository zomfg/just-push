//
//  JPCertificate.h
//  JustPush
//
//  Created by John Doe on 18/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPCertificate : NSObject

@property (nonatomic, readonly) NSString* commonName;
@property (nonatomic, readonly) NSData* fingerprint;
@property (nonatomic, readonly) NSString* bundleId;

+ (NSArray *) fetchAll;
+ (JPCertificate *) certificateWithFingerprint:(NSData *)fingerprint;
+ (NSArray *) certificatesWithBundleId:(NSString *)bundleId;


@end
