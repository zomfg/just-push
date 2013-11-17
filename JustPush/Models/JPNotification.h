//
//  JPNotification.h
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+ActiveRecord.h"

@class JPApp, JPPayload;

@interface JPNotification : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) BOOL sandbox;
@property (nonatomic, retain) id certificate;
@property (nonatomic, retain) JPApp *app;
@property (nonatomic, retain) NSArray *tokens; // JPDeviceToken
@property (nonatomic, retain) JPPayload *payload;

@end
