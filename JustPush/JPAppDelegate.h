//
//  JPAppDelegate.h
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JPNotificationViewController;

@interface JPAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSArrayController *notificationArrayController;
@property (weak) IBOutlet JPNotificationViewController *notificationViewController;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
