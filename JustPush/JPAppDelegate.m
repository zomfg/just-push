//
//  JPAppDelegate.m
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPAppDelegate.h"

#import "JPApp.h"
#import "JPDeviceToken.h"
#import "JPPayload.h"
#import "JPDevice.h"
#import "JPNotification.h"

@implementation JPAppDelegate

#pragma mark - CoreData stack

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;


// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"JustPush" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"JustPush.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

#pragma mark - App runtime

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
//    JPApp* newApp = nil;
//    newApp = [JPApp create:@{@"name": @"Star Wars", @"icon" : [NSImage imageNamed:@"default_app_icon.png"]}];
//    [newApp save];
//    newApp = [JPApp create:@{@"name": @"Sport Quiz", @"icon" : [NSImage imageNamed:@"default_app_icon.png"]}];
//    [newApp save];
//
//    JPDeviceToken* newToken = nil;
//    newToken = [JPDeviceToken create:@{@"token": @"62", @"sandbox" : @(YES)}];
//    newToken.app = newApp;
//    [newToken save];
//    newToken = [JPDeviceToken create:@{@"token": @"43", @"sandbox" : @(YES)}];
//    newToken.app = newApp;
//    [newToken save];
//    newToken = [JPDeviceToken create:@{@"token": @"52", @"sandbox" : @(NO)}];
//    newToken.app = newApp;
//    [newToken save];
//
    JPNotification* newNotif = nil;
//    newNotif = [JPNotification create:@{@"app": newApp, @"sandbox" : @(YES)}];
//    [newNotif save];
//    return;

    newNotif = [JPNotification all][0];
    NSLog(@"TOKENS (%lu) FOR NOTIF %@", (unsigned long)newNotif.tokens.count, newNotif.tokens);


//    JPApp* oldApp = [JPApp where:@"name == 'Angry Birds'"][0];
//    NSLog(@"SOME APP %@ %@", oldApp.name, oldApp.icon == nil ? @"NO ICON :(" : NSStringFromSize(oldApp.icon.size));
//    for (JPApp* app in [JPApp all]) {
//        NSLog(@"%@ HAS %lu TOKENS", app.name, (unsigned long)app.tokens.count);
//        for (JPDeviceToken* deviceToken in app.tokens) {
//            NSLog(@"%@ %@", deviceToken.token, deviceToken.sandbox ? @"sandbox" : @"production");
//        }
//    }

//    JPPayload* pl = [JPPayload create:@{@"body": @"coucou"}];
//    NSLog(@"%@\n%@", pl.JSON, pl.prettyJSON);

//    JPDevice* device = nil;
//    device = [JPDevice create:@{@"typeIdentifier": @"com.apple.ipad-mini2-A1517-99989b"}];
//    [device save];
//    device = [JPDevice where:@"typeIdentifier == 'com.apple.ipad-mini2-A1517-99989b'"][0];
//    NSLog(@"[%@] %@ %@", device.typeIdentifier, device.description, NSStringFromSize(device.icon.size));
//    device.typeIdentifier = @"com.apple.iphone";
//    NSLog(@"[%@] %@ %@", device.typeIdentifier, device.description, NSStringFromSize(device.icon.size));
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "com.showire.JustPush" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
