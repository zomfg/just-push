//
//  JPNotification.m
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPNotification.h"
#import "JPApp.h"
#import "JPDeviceToken.h"


@implementation JPNotification

@dynamic name;
@dynamic sandbox;
@dynamic certificate;
@dynamic app;
@dynamic payload;

- (NSArray *) tokens {
    return [JPDeviceToken where:@{@"app" : self.app, @"sandbox" : @(self.sandbox)}];
}

- (NSUInteger) numberOfDeviceTokens {
    return [JPDeviceToken countWhere:@{@"app" : self.app, @"sandbox" : @(self.sandbox)}];
}

+ (NSSet *) keyPathsForValuesAffectingTokens {
    return [NSSet setWithObjects:@"app", @"sandbox", nil];
}

+ (NSSet *) keyPathsForValuesAffectingNumberOfDeviceTokens {
    return [self keyPathsForValuesAffectingTokens];
}

@end
