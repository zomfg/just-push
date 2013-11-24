//
//  JPNotificationViewController.h
//  JustPush
//
//  Created by John Doe on 23/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JPCertificateMenuItem : NSMenuItem

@property (nonatomic, strong) NSString* subtitle;

@end

@class JPNotification;

@interface JPNotificationViewController : NSViewController

@property (nonatomic, readonly) JPNotification *notification;

@property (nonatomic, weak) IBOutlet NSPopUpButton* certificatesButton;
@property (nonatomic, weak) IBOutlet NSTextField* payloadLengthLabel;

- (IBAction) selectedNewCertificate:(NSPopUpButton *)sender;
- (IBAction) copyPayloadToPasteboard:(id)sender;

@end
