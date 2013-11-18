//
//  JPApp.h
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+ActiveRecord.h"

@interface JPApp : NSManagedObject

@property (nonatomic, retain) NSString * iTunesAppId;
@property (nonatomic, retain) NSString * bundleId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSImage *icon;
@property (nonatomic, retain) NSArray *tokens; // JPDeviceToken
@property (nonatomic, retain) NSArray *notifications; // JPNotifications

@end
