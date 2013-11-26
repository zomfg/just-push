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

@end

@interface JPNotificationIOS7PreviewViewController : JPNotificationPreviewViewController

@property (nonatomic, readonly) NSAttributedString* previewActionLocKey;
@property (nonatomic, readonly) NSAttributedString* previewAppName;
@property (nonatomic, readonly) NSString* previewMessage;
@property (nonatomic, readonly) NSImage* previewBackground;
@property (nonatomic, readonly) NSImage* previewAppIcon;

@end
