//
//  JPPayload.m
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPPayload.h"
#import "JPNotification.h"

static NSString* const kPayloadKeyAPS                  = @"aps";
static NSString* const kPayloadKeyBadge                = @"badge";
static NSString* const kPayloadKeySound                = @"sound";
static NSString* const kPayloadKeyContentAvailable     = @"content-available";
static NSString* const kPayloadKeyAlert                = @"alert";
static NSString* const kPayloadKeyAlertBody            = @"body";
static NSString* const kPayloadKeyAlertActionLocKey    = @"action-loc-key";
static NSString* const kPayloadKeyAlertLocKey          = @"loc-key";
static NSString* const kPayloadKeyAlertLocArgs         = @"loc-args";
static NSString* const kPayloadKeyAlertLaunchImage     = @"launch-image";

static NSString* const kPayloadLocArgsDelimiter        = @",";

@implementation JPPayload

@dynamic message;
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
    id alert = [NSMutableDictionary dictionary];

    if (self.actionLocKey.length > 0)
        [alert setObject:self.actionLocKey forKey:kPayloadKeyAlertActionLocKey];

    if (self.locKey.length > 0) {
        [alert setObject:self.locKey forKey:kPayloadKeyAlertLocKey];
        if (self.locArgs > 0) {
            NSArray* args = [self.locArgs componentsSeparatedByString:kPayloadLocArgsDelimiter];
            if (args.count > 0)
                [alert setObject:args forKey:kPayloadKeyAlertLocArgs];
        }
    }
    else if (self.message.length > 0)
        [alert setObject:self.message forKey:kPayloadKeyAlertBody];

    if (self.launchImage.length > 0)
        [alert setObject:self.launchImage forKey:kPayloadKeyAlertLaunchImage];

    if ([alert isEmpty] && self.message.length > 0)
        alert = self.message;

    NSMutableDictionary* apsDico = [NSMutableDictionary dictionary];
    if (alert)
        [apsDico setObject:alert forKey:kPayloadKeyAlert];
    if (self.sound.length > 0)
        [apsDico setObject:self.sound forKey:kPayloadKeySound];
    if (self.badge)
        [apsDico setObject:self.badge forKey:kPayloadKeyBadge];
    if (self.contentAvailable)
        [apsDico setObject:@1 forKey:kPayloadKeyContentAvailable];

    NSError *error = nil;
    NSDictionary* customDico = nil;
    if (self.customFields) {
        const char * bytes = [self.customFields UTF8String];
        NSData *customData = [[NSData alloc] initWithBytes:bytes length:strlen(bytes)];
        if (customData)
            customDico = [NSJSONSerialization JSONObjectWithData:customData options:NSJSONReadingAllowFragments error:&error];
        if (error)
            NSLog(@"[%@ customFields]: %@", NSStringFromClass(self.class), error);
    }
    NSMutableDictionary* payloadDico = [[NSMutableDictionary alloc] initWithObjectsAndKeys:apsDico, kPayloadKeyAPS, nil];
    [payloadDico addEntriesFromDictionary:customDico];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDico
                                                       options:(pretty ? NSJSONWritingPrettyPrinted : 0) // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = nil;
    if (!jsonData)
        NSLog(@"[%@ generateJSON]: %@", NSStringFromClass(self.class), error);
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

- (NSString *) description {
    return [self JSON];
}

@end
