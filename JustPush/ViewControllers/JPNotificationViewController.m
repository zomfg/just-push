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

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqualTo:self.representedObject] && [keyPath isEqualToString:@"sandbox"])
        [self refreshCertificatesList];
}

- (void) setRepresentedObject:(id)representedObject {
    [self.representedObject removeObserver:self forKeyPath:@"sandbox"];
    [representedObject addObserver:self forKeyPath:@"sandbox" options:NSKeyValueObservingOptionNew context:NULL];
    [self willChangeValueForKey:@"notification"];
    [self willChangeValueForKey:@"certificateIcon"];
    [super setRepresentedObject:representedObject];
    [self didChangeValueForKey:@"notification"];
    [self didChangeValueForKey:@"certificateIcon"];
    [self refreshCertificatesList];
}

- (JPNotification *) notification {
    return self.representedObject;
}

- (void) refreshCertificatesList {
    NSArray* certificates = [JPCertificate certificatesWithBundleId:self.notification.app.bundleId
                                                            sandbox:self.notification.sandbox];
    [self.certificatesButton removeAllItems];
    NSMenuItem* item = nil;
    for (JPCertificate* certificate in certificates) {
        [self.certificatesButton addItemWithTitle:certificate.commonName];
        self.certificatesButton.lastItem.image = [NSImage imageNamed:@"CertSmallStd"];
    }
    if (certificates.count < 1) {
        [self.certificatesButton addItemWithTitle:@"Add a valid APNS Certificate to your Keychain"];
        item = self.certificatesButton.lastItem;
        item.image = [NSImage imageNamed:@"Keychain"];
    } else if (self.notification.certificate) {
        if (self.notification.certificate.sandbox != self.notification.sandbox) {
            [self.certificatesButton addItemWithTitle:self.notification.certificate.commonName];
            item = self.certificatesButton.lastItem;
            item.image = [NSImage imageNamed:@"CertSmallStd_Invalid"];
        }
        [self.certificatesButton selectItemWithTitle:self.notification.certificate.commonName];
    } else if (self.notification.app.bundleId.length > 0)
        [self.certificatesButton selectItem:self.certificatesButton.lastItem];
    else {
        [self.certificatesButton addItemWithTitle:@"Select a valid APNS Certificate"];
        item = self.certificatesButton.lastItem;
        item.image = [NSImage imageNamed:@"CertSmallPersonal"];
        [self.certificatesButton selectItem:item];
    }
}

@end
