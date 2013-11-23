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

@property (nonatomic, retain) IBOutlet NSTextField* deviceNumberText;
@property (nonatomic, retain) IBOutlet NSTextField* environementText;
@property (nonatomic, retain) IBOutlet NSImageView* identityStatusView;

@property (nonatomic, readonly) NSImage* deviceIcon;

@end
