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

- (NSString *) environement {
    return ((JPNotification*)self.objectValue).sandbox ? @"Sandbox" : @"Production";
}

- (NSNumber *) numberOfDevices {
    return @(((JPNotification*)self.objectValue).tokens.count);
}

- (void) setObjectValue:(id)objectValue {
    [super setObjectValue:objectValue];
    self.environementText.stringValue = [self environement];
    self.deviceNumberText.stringValue = [self numberOfDevices].stringValue;
}

- (NSImage *) deviceIcon {
    NSDictionary* devices = [JPDevice mobileDevices];
    NSString* key = devices.allKeys.sample;
    return devices[key][kJPTypeIconImageKey];
}

@end
