//
//  JPPayloadIOS7PreviewViewController.h
//  JustPush
//
//  Created by John Doe on 25/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JPNotification;

@interface JPNotificationPreviewViewController : NSViewController

@property (nonatomic, weak) JPNotification* notification;

@property (nonatomic, readonly) NSString* message;

@end

@interface JPNotificationIOS7PreviewViewController : JPNotificationPreviewViewController

@property (nonatomic, readonly) NSString* wallpaperName;
@property (nonatomic, readonly) NSImage* wallpaperImage;
@property (nonatomic, readonly) NSImage* backgroundImage;
@property (nonatomic, readonly) NSColor* subtextColor;
@property (nonatomic, readonly) NSAttributedString* appName;
@property (nonatomic, readonly) NSAttributedString* actionLocKey;
@property (nonatomic, readonly) NSImage* appIcon;

@end
