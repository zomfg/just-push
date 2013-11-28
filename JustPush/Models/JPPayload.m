//
//  JPPayload.m
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPPayload.h"
#import "JPNotification.h"

const NSInteger kJPPayloadLengthLimit              = 256;

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

static NSString* const kPayloadLocArgsDelimiter        = @"|";

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
    NSMutableDictionary *apsHash   = [NSMutableDictionary dictionary];
    NSMutableDictionary *alertHash = [NSMutableDictionary dictionary];

    if (self.actionLocKey.length > 0)
        alertHash[kPayloadKeyAlertActionLocKey] = self.actionLocKey;
    
    if (self.launchImage.length > 0)
        alertHash[kPayloadKeyAlertLaunchImage] = self.launchImage;

    if (self.locKey.length > 0) {
        alertHash[kPayloadKeyAlertLocKey] = self.locKey;
        NSArray* args = self.locArgsArray;
        if (args.count > 0)
            alertHash[kPayloadKeyAlertLocArgs] = args;
    }
    else if (self.message.length > 0 && alertHash.count > 0)
        alertHash[kPayloadKeyAlertBody] = self.message;
    else if (self.message.length > 0)
        apsHash[kPayloadKeyAlert] = self.message;
    if (alertHash.count > 0)
        apsHash[kPayloadKeyAlert] = alertHash;

    if (self.sound.length > 0)
        apsHash[kPayloadKeySound] = self.sound;
    if (self.badge)
        apsHash[kPayloadKeyBadge] = self.badge;
    if (self.contentAvailable)
        apsHash[kPayloadKeyContentAvailable] = @1;
    
    NSMutableDictionary* payloadHash = [NSMutableDictionary dictionary];
    if (apsHash.count > 0)
        payloadHash[kPayloadKeyAPS] = apsHash;

    NSError *error = nil;
    if (self.customFields) {
        const char * bytes = [self.customFields UTF8String];
        NSDictionary* customHash = [NSJSONSerialization JSONObjectWithData:[NSData dataWithBytes:bytes length:strlen(bytes)]
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:&error];
        if (error)
            NSLog(@"[%@ customFields]: %@", NSStringFromClass(self.class), error);
        else if (customHash)
            [payloadHash addEntriesFromDictionary:customHash];
    }

    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:payloadHash
                                                       options:(pretty ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    if (!JSONData)
        NSLog(@"[%@ generateJSON]: %@", NSStringFromClass(self.class), error);
    else
        return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    return nil;
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

- (NSArray *) locArgsArray {
    return self.locArgs.length > 0 ? [self.locArgs componentsSeparatedByString:kPayloadLocArgsDelimiter] : nil;
}

- (BOOL) validateCustomFields:(NSString *__autoreleasing *)value error:(NSError *__autoreleasing *)error {
    if (error)
        *error = nil;
    if ((*value).length < 1)
        return YES;
    const char * bytes = [*value UTF8String];
    id result = [NSJSONSerialization JSONObjectWithData:[NSData dataWithBytes:bytes length:strlen(bytes)]
                                                options:NSJSONReadingAllowFragments error:error];
    return ([result isKindOfClass:[NSDictionary class]] && (error == NULL || *error == nil));
}

+ (NSSet *) keyPathsForValuesAffectingJSON {
    return [NSSet setWithObjects:@"message", @"locKey", @"locArgs", @"actionLocKey", @"launchImage", @"badge", @"sound", @"contentAvailable", @"customFields", nil];
}

+ (NSSet *) keyPathsForValuesAffectingPrettyJSON {
    return [self keyPathsForValuesAffectingJSON];
}

@end
