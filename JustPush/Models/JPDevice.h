//
//  JPDevice.h
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+ActiveRecord.h"

extern NSString* const kJPTypeIconImageKey;

@interface JPDevice : NSManagedObject

@property (nonatomic, retain) NSString * typeIdentifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSArray *tokens; // JPDeviceToken

@property (nonatomic, readonly) NSString* iconFileName;
@property (nonatomic, readonly) NSImage* icon;

+ (NSDictionary *) mobileDevices;

@end
