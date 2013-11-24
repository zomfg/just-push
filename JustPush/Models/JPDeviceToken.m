//
//  JPDeviceToken.m
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPDeviceToken.h"


@implementation JPDeviceToken

@dynamic token;
@dynamic sandbox;
@dynamic device;
@dynamic app;

- (NSData *) tokenData {
    NSMutableData *deviceTokenData = [NSMutableData data];
	unsigned value;
	NSScanner *scanner = [NSScanner scannerWithString:self.token];
	while (![scanner isAtEnd]) {
		[scanner scanHexInt:&value];
		value = htonl(value);
		[deviceTokenData appendBytes:&value length:sizeof(value)];
	}
    return deviceTokenData;
}

@end
