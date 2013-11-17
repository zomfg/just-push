//
//  JPDeviceToken.h
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+ActiveRecord.h"

@class JPDevice, JPApp;

@interface JPDeviceToken : NSManagedObject

@property (nonatomic, retain) NSString * token;
@property (nonatomic) BOOL sandbox;
@property (nonatomic, retain) JPDevice *device;
@property (nonatomic, retain) JPApp *app;
@property (nonatomic, retain) NSArray *notifications; // JPNotification

@end
