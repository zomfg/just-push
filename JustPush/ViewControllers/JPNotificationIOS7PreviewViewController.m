//
//  JPPayloadIOS7PreviewViewController.m
//  JustPush
//
//  Created by John Doe on 25/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPNotificationIOS7PreviewViewController.h"
#import "JPNotification.h"
#import "JPPayload.h"
#import "JPApp.h"
#import "NSImage+Effects.h"

static const NSUInteger kJPPayloadMessageTruncateThreshold = 138;

@implementation JPNotificationPreviewViewController
@end

@interface JPNotificationIOS7PreviewViewController ()

@end

@implementation JPNotificationIOS7PreviewViewController

- (NSImage *) previewBackground {
    return [[[NSImage imageNamed:@"preview_wallpaper"] blurry:12.0] darken:0.5];
}

+ (NSSet *) keyPathsForValuesAffectingPreviewAppIcon {
    return [NSSet setWithObject:@"notification.app.icon"];
}

- (NSImage *) previewAppIcon {
    return [self.notification.app.icon roundCorners:0.2f];
}

+ (NSSet *) keyPathsForValuesAffectingPreviewActionLocKey {
    return [NSSet setWithObject:@"notification.payload.actionLocKey"];
}

- (NSAttributedString *) previewActionLocKey {
    NSString* previewString = [NSString stringWithFormat:@"slide to %@", self.notification.payload.actionLocKey ? self.notification.payload.actionLocKey : @"view"];
    NSDictionary* attributes = @{NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue-Light" size:12.3f],
                                 NSForegroundColorAttributeName : [NSColor colorWithRed:44/255.0 green:108/255.0 blue:145/255.0 alpha:1.0]};
    return [[NSAttributedString alloc] initWithString:previewString attributes:attributes];
}

+ (NSSet *) keyPathsForValuesAffectingPreviewAppName {
    return [NSSet setWithObject:@"notification.app.name"];
}

- (NSAttributedString *) previewAppName {
    NSString* appName = self.notification.app.name ? self.notification.app.name : @"App Name";
    NSString* previewString = [NSString stringWithFormat:@"%@ now", appName];
    NSMutableAttributedString* preview = [[NSMutableAttributedString alloc] initWithString:previewString];
    
    NSDictionary* attributes = @{NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue-Light" size:17.0f],
                                 NSForegroundColorAttributeName : [NSColor whiteColor]};
    [preview addAttributes:attributes range:[previewString rangeOfString:appName]];
    
    attributes = @{NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue-Light" size:12.3f],
                   NSForegroundColorAttributeName : [NSColor colorWithRed:44/255.0 green:108/255.0 blue:145/255.0 alpha:1.0]};
    [preview addAttributes:attributes range:[previewString rangeOfString:@"now"]];
    return preview;
}

+ (NSSet *) keyPathsForValuesAffectingPreviewMessage {
    return [NSSet setWithObjects:@"notification.payload.message", nil];
}

- (NSString *) previewMessage {
    NSString* preview = self.notification.payload.message ? self.notification.payload.message : @"Message";
    if (preview.length > kJPPayloadMessageTruncateThreshold)
        return [NSString stringWithFormat:@"%@...", [self.notification.payload.message substringToIndex:kJPPayloadMessageTruncateThreshold]];
    return preview;
}

@end
