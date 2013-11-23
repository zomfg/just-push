//
//  JPNotificationTableCellView.h
//  JustPush
//
//  Created by John Doe on 17/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JPNotification;

@interface JPNotificationTableCellView : NSTableCellView

@property (nonatomic, readonly) JPNotification *notification;
@property (nonatomic, readonly) NSString       *environment;
@property (nonatomic, readonly) NSString       *numberOfDevices;
@property (nonatomic, readonly) NSImage        *deviceIcon;
@property (nonatomic, readonly) NSImage        *identityStatusIcon;

@end
