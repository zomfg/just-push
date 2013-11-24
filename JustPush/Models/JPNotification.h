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

@class JPApp, JPPayload, JPCertificate;

@interface JPNotification : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) BOOL sandbox;
@property (nonatomic, retain) JPCertificate *certificate;
@property (nonatomic, retain) JPApp *app;
@property (nonatomic, retain) JPPayload *payload;

@property (nonatomic, readonly) NSArray *tokens; // JPDeviceToken
@property (nonatomic, readonly) NSUInteger numberOfDeviceTokens;

@end
