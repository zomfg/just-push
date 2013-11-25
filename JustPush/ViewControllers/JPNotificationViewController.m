//
//  JPNotificationViewController.m
//  JustPush
//
//  Created by John Doe on 23/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPNotificationViewController.h"
#import "JPNotification.h"
#import "JPCertificate.h"
#import "JPApp.h"
#import "JPPayload.h"
#import "JPPusher.h"

typedef enum {
    JPCertificateMenuItemNoValueType,
    JPCertificateMenuItemNoContentType
} JPCertificateMenuItemType;

@implementation JPCertificateMenuItem

+ (id) itemWithType:(JPCertificateMenuItemType)type {
    JPCertificateMenuItem* item = [JPCertificateMenuItem new];
    if (type == JPCertificateMenuItemNoContentType) {
        item.title = @"Add a valid APNS Certificate to your Keychain";
        item.image = [NSImage imageNamed:@"Keychain"];
    } else if (type == JPCertificateMenuItemNoValueType) {
        item.title = @"Select a valid APNS Certificate";
        item.image = [NSImage imageNamed:@"CertSmallPersonal"];
    }
    return item;
}

+ (id) itemWithCertificate:(JPCertificate *)certificate sandbox:(BOOL)sandbox {
    JPCertificateMenuItem* item = [JPCertificateMenuItem new];
    [item configureForCertificate:certificate sandbox:sandbox];
    return item;
}

- (void) configureForCertificate:(JPCertificate *)certificate sandbox:(BOOL)sandbox {
    self.subtitle = [NSString stringWithFormat:@"MD5 Fingerprint: %@", certificate.fingerprintString];
    NSString* title = [NSString stringWithFormat:@"%@\n%@", certificate.commonName, self.subtitle];
    NSMutableAttributedString* attributedTitle = [[NSMutableAttributedString alloc] initWithString:title];

    NSDictionary* attributes = @{NSFontAttributeName : [NSFont systemFontOfSize:[NSFont systemFontSize]]};
    [attributedTitle addAttributes:attributes range:[title rangeOfString:certificate.commonName]];
    attributes = @{NSFontAttributeName : [NSFont systemFontOfSize:[NSFont systemFontSize] * 0.9f],
                   NSForegroundColorAttributeName : [NSColor disabledControlTextColor]};
    [attributedTitle addAttributes:attributes range:[title rangeOfString:self.subtitle]];

    self.attributedTitle = attributedTitle;
    self.representedObject = certificate;
    self.image = [NSImage imageNamed:(sandbox == certificate.sandbox ? @"CertSmallStd" : @"CertSmallStd_Invalid")];
}

@end

@interface JPNotificationViewController ()

@end

@implementation JPNotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) dealloc {
    [self.representedObject removeObserver:self forKeyPath:@"sandbox"];
}

#pragma mark - KVO

+ (NSSet *) keyPathsForValuesAffectingNotification {
    return [NSSet setWithObject:@"representedObject"];
}

+ (NSSet *) keyPathsForValuesAffectingPayloadLengthColor {
    return [NSSet setWithObject:@"notification.payload.JSON"];
}

+ (NSSet *) keyPathsForValuesAffectingPayloadRemainingLength {
    return [self keyPathsForValuesAffectingPayloadLengthColor];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqualTo:self.representedObject] && [keyPath isEqualToString:@"sandbox"])
        [self refreshCertificatesList];
}

- (void) setRepresentedObject:(id)representedObject {
    [self.representedObject removeObserver:self forKeyPath:@"sandbox"];
    [representedObject addObserver:self forKeyPath:@"sandbox" options:0 context:NULL];
    [super setRepresentedObject:representedObject];
    [self refreshCertificatesList];
}

- (NSInteger) payloadRemainingLength {
    return kJPPayloadLengthLimit - self.notification.payload.JSON.length;
}

- (NSColor *) payloadLengthColor {
    return kJPPayloadLengthLimit < self.notification.payload.JSON.length ? [NSColor redColor] : [NSColor textColor];
}

- (JPNotification *) notification {
    return self.representedObject;
}

- (void) refreshCertificatesList {
    NSArray* certificates = [JPCertificate certificatesWithBundleId:self.notification.app.bundleId
                                                            sandbox:self.notification.sandbox];
    [self.certificatesButton removeAllItems];
    JPCertificateMenuItem* item = nil;
    for (JPCertificate* certificate in certificates) {
        item = [JPCertificateMenuItem itemWithCertificate:certificate sandbox:self.notification.sandbox];
        [self.certificatesButton.menu addItem:item];
        if ([certificate.fingerprint isEqualToData:self.notification.certificate.fingerprint])
            [self.certificatesButton selectItem:item];
    }
    if (certificates.count < 1)
        [self.certificatesButton.menu addItem:[JPCertificateMenuItem itemWithType:JPCertificateMenuItemNoContentType]];
    else if (self.notification.certificate && self.notification.certificate.sandbox != self.notification.sandbox) {
        item = [JPCertificateMenuItem itemWithCertificate:self.notification.certificate sandbox:self.notification.sandbox];
        [self.certificatesButton.menu addItem:item];
        [self.certificatesButton selectItem:item];
    } else if (self.notification.app.bundleId.length > 0)
        [self.certificatesButton selectItem:self.certificatesButton.lastItem];
    else if (self.notification.certificate == nil) {
        item = [JPCertificateMenuItem itemWithType:JPCertificateMenuItemNoValueType];
        [self.certificatesButton.menu addItem:item];
        [self.certificatesButton selectItem:item];
    }
    [self selectedNewCertificate:self.certificatesButton];
}

#pragma mark - Actions

- (IBAction) selectedNewCertificate:(NSPopUpButton *)sender {
    if ([sender.selectedItem.representedObject isKindOfClass:[JPCertificate class]])
        self.notification.certificate = sender.selectedItem.representedObject;
}

- (IBAction) copyPayloadToPasteboard:(id)sender {
    NSPasteboard* pboard = [NSPasteboard generalPasteboard];
    [pboard clearContents];
    [pboard setString:self.notification.payload.JSON forType:NSPasteboardTypeString];
}

- (IBAction) push:(id)sender {
    JPPusher* pusher = [JPPusher pusherWithNotification:self.notification];
    [pusher push];
}

@end
