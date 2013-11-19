//
//  JPCertificateToDataTransformer.m
//  JustPush
//
//  Created by John Doe on 19/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPCertificateToDataTransformer.h"
#import "JPCertificate.h"

@implementation JPCertificateToDataTransformer

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

+ (Class)transformedValueClass
{
    return [NSData class];
}

- (id)transformedValue:(JPCertificate *)value
{
    return value.fingerprint;
}

- (id)reverseTransformedValue:(NSData *)value
{
    return [JPCertificate certificateWithFingerprint:value];
}

@end
