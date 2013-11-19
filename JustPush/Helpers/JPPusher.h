//
//  JPPusher.h
//  JustPush
//
//  Created by Sergio Kunats on 11/19/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JPNotification;

@interface JPPusher : NSObject

+ (void) push:(JPNotification *)notification;

@end
