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

@implementation JPNotificationPreviewViewController

+ (NSSet *) keyPathsForValuesAffectingMessage {
    return [NSSet setWithObjects:@"notification.payload.message", @"notification.payload.locArgs", nil];
}

- (NSString *) message {
    NSString* preview = self.notification.payload.message ? self.notification.payload.message : @"Message";
    if (self.notification.payload.locArgs.length) {
        NSArray* args = self.notification.payload.locArgsArray;
        if (args.count > 0) {
            NSMutableString* p = preview.mutableCopy;
            for (NSString* arg in args) {
                NSRange range = [p rangeOfString:@"%@"];
                if (range.location == NSNotFound)
                    break;
                [p replaceCharactersInRange:[p rangeOfString:@"%@"]
                                 withString:arg];
            }
            preview = p;
        }
    }
    return preview;
}


@end

@interface JPNotificationIOS7PreviewViewController ()

@end

@implementation JPNotificationIOS7PreviewViewController

- (NSString *) wallpaperName {
    return @"preview_wallpaper";
}

+ (NSSet *) keyPathsForValuesAffectingBackgroundImage {
    return [NSSet setWithObject:@"notification"];
}

- (NSImage *) wallpaperImage {
    return [NSImage imageNamed:@"preview_wallpaper"];
}

- (NSColor *) subtextColor {
    return [self.wallpaperImage averageColor];
}

- (NSImage *) backgroundImage {
    return [[self.wallpaperImage blurry:20.0] darken:0.5];
}

+ (NSSet *) keyPathsForValuesAffectingAppIcon {
    return [NSSet setWithObject:@"notification.app.icon"];
}

- (NSImage *) appIcon {
    return [self.notification.app.icon roundCorners:0.2f];
}

+ (NSSet *) keyPathsForValuesAffectingActionLocKey {
    return [NSSet setWithObject:@"notification.payload.actionLocKey"];
}

- (NSAttributedString *) actionLocKey {
    NSString* previewString = [NSString stringWithFormat:@"slide to %@", self.notification.payload.actionLocKey ? self.notification.payload.actionLocKey : @"view"];
    NSDictionary* attributes = @{NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue-Medium" size:11.5f],
                                 NSKernAttributeName : @0.5,
                                 NSForegroundColorAttributeName : self.subtextColor};
    return [[NSAttributedString alloc] initWithString:previewString attributes:attributes];
}

+ (NSSet *) keyPathsForValuesAffectingAppName {
    return [NSSet setWithObject:@"notification.app.name"];
}
/*
just push dghfhfh fhhfgh  jhjg hgjfj  jgjh ghjhjjgh ghjgj gjgjghjj jg jhj gjhg jghj gjgjghjg jhgjhjghj ghj j gh jghj ghjg j gjgh ghjghj ghjghjhg fg|dfdkfjskfskdfjsfk
 */
- (NSAttributedString *) appName {
    NSString* appName = self.notification.app.name ? self.notification.app.name : @"App Name";
    NSString* previewString = [NSString stringWithFormat:@"%@ now", appName];
    NSMutableAttributedString* preview = [[NSMutableAttributedString alloc] initWithString:previewString];
    
    NSDictionary* attributes = @{NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue-Medium" size:15.0f],
                                 NSKernAttributeName : @0.5,
                                 NSForegroundColorAttributeName : [NSColor whiteColor]};
    [preview addAttributes:attributes range:[previewString rangeOfString:appName]];
    
    attributes = @{NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue-Medium" size:11.5f],
                   NSKernAttributeName : @0.5,
                   NSForegroundColorAttributeName : self.subtextColor};
    [preview addAttributes:attributes range:[previewString rangeOfString:@"now"]];
    return preview;
}

- (NSString *) message {
    NSDictionary* attributes = @{NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue-Light" size:15.0f],
                                 NSKernAttributeName : @0.85,
                                 NSForegroundColorAttributeName : [NSColor whiteColor]};
    return (NSString *)[[NSAttributedString alloc] initWithString:[super message] attributes:attributes];
}

@end
