//
//  JPNotificationTableCellView.m
//  JustPush
//
//  Created by John Doe on 17/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPNotificationTableCellView.h"
#import "JPNotification.h"
#import "JPCertificate.h"
#import "JPDevice.h"
#import "ObjectiveSugar.h"

@implementation JPNotificationTableCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (JPNotification *) notification {
    return self.objectValue;
}

- (NSString *) environment {
    return self.notification.sandbox ? @"Sandbox" : @"Production";
}

- (NSNumber *) numberOfDevices {
    return @(self.notification.numberOfDeviceTokens);
}

- (NSImage *) identityStatusIcon {
    if (self.notification.certificate.identity)
        return [NSImage imageNamed:@"NSStatusAvailable"];
    return [NSImage imageNamed:@"NSStatusUnavailable"];
}

- (void) setObjectValue:(id)objectValue {
    [self willChangeValueForKey:@"notification"];
    [self willChangeValueForKey:@"environment"];
    [self willChangeValueForKey:@"numberOfDevices"];
    [self willChangeValueForKey:@"identityStatusIcon"];
    [super setObjectValue:objectValue];
    [self didChangeValueForKey:@"notification"];
    [self didChangeValueForKey:@"environment"];
    [self didChangeValueForKey:@"numberOfDevices"];
    [self didChangeValueForKey:@"identityStatusIcon"];
}

- (NSImage *) deviceIcon {
    NSDictionary* devices = [JPDevice mobileDevices];
    NSString* key = devices.allKeys.sample;
    return devices[key][kJPTypeIconImageKey];
}

@end
