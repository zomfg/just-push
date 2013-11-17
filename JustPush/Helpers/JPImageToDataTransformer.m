//
//  JPImageToDataTransformer.m
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPImageToDataTransformer.h"

@implementation JPImageToDataTransformer

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

+ (Class)transformedValueClass
{
    return [NSData class];
}

- (id)transformedValue:(id)value
{
    NSBitmapImageRep *rep = [value representations][0];
    NSData *data = [rep representationUsingType:NSPNGFileType
                                     properties:nil];
    return data;
}

- (id)reverseTransformedValue:(id)value
{
    return [[NSImage alloc] initWithData:value];
}

@end
