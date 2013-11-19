//
//  JPPayload.h
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+ActiveRecord.h"

@interface JPPayload : NSManagedObject

@property (nonatomic, retain) NSString * alert;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * actionLocKey;
@property (nonatomic, retain) NSString * locKey;
@property (nonatomic, retain) NSString * locArgs;
@property (nonatomic, retain) NSString * launchImage;
@property (nonatomic) BOOL contentAvailable;
@property (nonatomic, retain) NSNumber * badge;
@property (nonatomic, retain) NSString * sound;
@property (nonatomic, retain) NSString * customFields;
@property (nonatomic, retain) NSArray *notifications; //JPNotification

@property (nonatomic, readonly) NSString *JSON;
@property (nonatomic, readonly) NSString *prettyJSON;

@end
