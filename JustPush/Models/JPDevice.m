//
//  JPDevice.m
//  JustPush
//
//  Created by John Doe on 16/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPDevice.h"
#import "JPDeviceToken.h"

//NSString const*

NSString* const kJPTypeIconImageKey = @"JPTypeIconImage";

static NSMutableDictionary* _devices = nil;

@interface JPDevice ()

@property (nonatomic, retain) NSDictionary* deviceDetails;

@end

@implementation JPDevice

@synthesize deviceDetails;

@dynamic typeIdentifier;
@dynamic name;
@dynamic tokens;

+ (NSDictionary *) mobileDevices {
    if (_devices)
        return _devices;
    NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"MobileDevices" ofType:@"bundle"];
    NSBundle* mobileDevicesBundle = [NSBundle bundleWithPath:bundlePath];
    NSDictionary* info = [mobileDevicesBundle infoDictionary];
    _devices = [NSMutableDictionary new];
    for (NSDictionary* device in info[(NSString *)kUTExportedTypeDeclarationsKey]) {
        NSMutableDictionary* mutableDevice = [device mutableCopy];
        NSString* imagePath = [mobileDevicesBundle pathForImageResource:mutableDevice[(NSString *)kUTTypeIconFileKey]];
        mutableDevice[kJPTypeIconImageKey] = [[NSImage alloc] initWithContentsOfFile:imagePath];
        _devices[mutableDevice[(NSString *)kUTTypeIdentifierKey]] = mutableDevice;
    }
    return _devices;
}

+ (NSDictionary *) mobileDeviceWithTypeIdentifier:(NSString *)identifier {
    return [self mobileDevices][identifier];
}

+ (void) initialize {
    [self mobileDevices];
}

- (id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
    if ((self = [super initWithEntity:entity insertIntoManagedObjectContext:context]))
        if (self.typeIdentifier)
            self.deviceDetails = [[self class] mobileDeviceWithTypeIdentifier:self.typeIdentifier];
    return self;
}

- (void) setTypeIdentifier:(NSString *)typeIdentifier {
    NSString* key = @"typeIdentifier";
    [self willChangeValueForKey:key];
    [self setPrimitiveValue:typeIdentifier forKey:key];
    self.deviceDetails = [[self class] mobileDeviceWithTypeIdentifier:typeIdentifier];
    [self didChangeValueForKey:key];
}

- (NSString *) description {
    return self.deviceDetails[(NSString *)kUTTypeDescriptionKey];
}

- (NSString *) iconFileName {
    return self.deviceDetails[(NSString *)kUTTypeIconFileKey];
}

- (NSImage *) icon {
    return self.deviceDetails[kJPTypeIconImageKey];
}

@end
