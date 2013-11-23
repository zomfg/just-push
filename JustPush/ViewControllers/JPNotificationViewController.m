//
//  JPNotificationViewController.m
//  JustPush
//
//  Created by John Doe on 23/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPNotificationViewController.h"
#import "JPNotification.h"

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

- (void) setRepresentedObject:(id)representedObject {
    [self willChangeValueForKey:@"notification"];
    [super setRepresentedObject:representedObject];
    [self didChangeValueForKey:@"notification"];
}

- (JPNotification *) notification {
    return self.representedObject;
}

@end
