//
//  JPPayload.m
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPPayload.h"
#import "JPNotification.h"

NSString* const kPayloadKeyAPS                  = @"aps";
NSString* const kPayloadKeyBadge                = @"badge";
NSString* const kPayloadKeySound                = @"sound";
NSString* const kPayloadKeyContentAvailable     = @"content-available";
NSString* const kPayloadKeyAlert                = @"alert";
NSString* const kPayloadKeyAlertBody            = @"body";
NSString* const kPayloadKeyAlertActionLocKey    = @"action-loc-key";
NSString* const kPayloadKeyAlertLocKey          = @"loc-key";
NSString* const kPayloadKeyAlertLocArgs         = @"loc-args";
NSString* const kPayloadKeyAlertLaunchImage     = @"launch-image";

@implementation JPPayload

@dynamic alert;
@dynamic body;
@dynamic actionLocKey;
@dynamic locKey;
@dynamic locArgs;
@dynamic launchImage;
@dynamic contentAvailable;
@dynamic badge;
@dynamic sound;
@dynamic customFields;
@dynamic notifications;

- (NSString*) generateJSON:(BOOL)pretty {
    id alert = nil;
    if (self.alert && ![self.alert isEqualToString:@""])
        alert = self.alert;
    else {
        alert = [NSMutableDictionary dictionary];
        if (self.body && ![self.body isEqualToString:@""])
            [alert setObject:self.body forKey:kPayloadKeyAlertBody];
        if (self.actionLocKey && ![self.actionLocKey isEqualToString:@""])
            [alert setObject:self.actionLocKey forKey:kPayloadKeyAlertActionLocKey];
        if (self.locKey && ![self.locKey isEqualToString:@""])
            [alert setObject:self.locKey forKey:kPayloadKeyAlertLocKey];
        if (self.locArgs && ![self.locArgs isEqualToString:@""])
            [alert setObject:self.locArgs forKey:kPayloadKeyAlertLocArgs];
        if (self.launchImage && ![self.launchImage isEqualToString:@""])
            [alert setObject:self.launchImage forKey:kPayloadKeyAlertLaunchImage];
    }
    NSMutableDictionary* apsDico = [NSMutableDictionary new];
    if (alert)
        [apsDico setObject:alert forKey:kPayloadKeyAlert];
    if (self.sound && ![self.sound isEqualToString:@""])
        [apsDico setObject:self.sound forKey:kPayloadKeySound];
    if (self.badge && ![self.badge isEqualToString:@""])
        [apsDico setObject:self.badge forKey:kPayloadKeyBadge];
    if (self.contentAvailable)
        [apsDico setObject:@"1" forKey:kPayloadKeyContentAvailable];

    NSError *error = nil;
    NSDictionary* customDico = nil;
    if (self.customFields) {
        const char * bytes = [self.customFields UTF8String];
        NSData *customData = [[NSData alloc] initWithBytes:bytes length:strlen(bytes)];
        if (customData)
            customDico = [NSJSONSerialization JSONObjectWithData:customData options:NSJSONReadingAllowFragments error:&error];
    }
    NSMutableDictionary* payloadDico = [[NSMutableDictionary alloc] initWithObjectsAndKeys:apsDico, kPayloadKeyAPS, nil];
    [payloadDico addEntriesFromDictionary:customDico];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDico
                                                       options:(pretty ? NSJSONWritingPrettyPrinted : 0) // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = nil;
    if (!jsonData)
        NSLog(@"Got an error: %@", error);
    else
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSString *) JSON {
    return [self generateJSON:NO];
}

- (NSString *) prettyJSON {
    return [self generateJSON:YES];
}

@end
