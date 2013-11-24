//
//  JPCertificate.m
//  JustPush
//
//  Created by John Doe on 18/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "JPCertificate.h"
#import <Security/Security.h>
#import "NSData+Digest.h"
#import "ObjectiveSugar.h"

static NSMutableArray* _certificateCache = nil;

@interface JPCertificate () {
    SecIdentityRef _identity;
    CFStringRef _commonName;
    CFDataRef _der;
}

@property (nonatomic, assign) SecCertificateRef rawCertificate;

@end

@implementation JPCertificate

+ (NSArray *) fetchAll {
    if (_certificateCache)
        return _certificateCache;

    CFMutableDictionaryRef query = CFDictionaryCreateMutable(NULL, 5, NULL, NULL);
    CFDictionaryAddValue(query, kSecClass, kSecClassCertificate);
    CFDictionaryAddValue(query, kSecReturnRef, kCFBooleanTrue);
    CFDictionaryAddValue(query, kSecMatchLimit, kSecMatchLimitAll);
    CFDictionaryAddValue(query, kSecMatchTrustedOnly, kCFBooleanTrue);
    CFDictionaryAddValue(query, kSecMatchSubjectContains, @"IOS Push Services: ");

    CFArrayRef results = NULL;
    OSStatus status = SecItemCopyMatching(query, (CFTypeRef *)&results);
    CFRelease(query);
    if (status) {
        if (status != errSecItemNotFound)
            NSLog(@"Can't search keychain");
        return nil;
    }
    NSArray* items = (__bridge NSArray *)(results);
    _certificateCache = [[NSMutableArray alloc] initWithCapacity:items.count];
    for (id certificate in items) {
        JPCertificate* c = [[self alloc] initWithCertificate:(__bridge SecCertificateRef)(certificate)];
        if (c.identity != NULL) {
            [_certificateCache addObject:c];
            NSLog(@"%@", c);
        }
    }
    CFRelease(results);
    return _certificateCache;
}

+ (JPCertificate *) certificateWithFingerprint:(NSData *)fingerprint {
    for (JPCertificate *certificate in [self fetchAll])
        if ([certificate.fingerprint isEqualToData:fingerprint])
            return certificate;
    return nil;
}

+ (NSArray *) certificatesWithBundleId:(NSString *)bundleId sandbox:(BOOL)sandbox {
    
    NSMutableArray* results = [NSMutableArray new];
    for (JPCertificate* certificate in [self fetchAll])
        if (certificate.sandbox == sandbox && (bundleId.length < 1 || [certificate.bundleId isEqualToString:bundleId]))
            [results addObject:certificate];
    return results;
}

- (JPCertificate *) initWithCertificate:(SecCertificateRef)certificate {
    if ((self = [super init]))
        self.rawCertificate = certificate;
    return self;
}

- (void) dealloc {
    if (_commonName)
        CFRelease(_commonName);
    if (_der)
        CFRelease(_der);
    if (_identity)
        CFRelease(_identity);
}

- (NSString *) commonName {
    if (_commonName == NULL)
        SecCertificateCopyCommonName(self.rawCertificate, &_commonName);
    return (__bridge NSString *)_commonName;
}

- (NSData *) fingerprint {
    if (_der == NULL)
        _der = SecCertificateCopyData(self.rawCertificate);
    if (_der)
        return [(__bridge NSData *)_der MD5Digest];
    return nil;
}

- (NSString *) bundleId {
    return [self.commonName substringFromString:@": "];
}

- (BOOL) sandbox {
    return [self.commonName containsString:@"Development"];
}

- (SecIdentityRef) identity {
    if (_identity == NULL)
        SecIdentityCreateWithCertificate(NULL, self.rawCertificate, &_identity);
    return _identity;
}

- (NSString *) fingerprintString {
    if (self.fingerprint.length < 1)
        return nil;
    NSMutableString* formattedFingerPrint = [NSMutableString stringWithCapacity:self.fingerprint.length * 3 - 1];
    const unsigned char* bytes = self.fingerprint.bytes;
    for (NSUInteger i = 0; i < self.fingerprint.length; i++)
        [formattedFingerPrint appendFormat:i == 0 ? @"%02X" : @" %02X", bytes[i]];
    return formattedFingerPrint;
}

- (NSString *) description {
    return [@{@"commonName": self.commonName,
              @"bundleId": self.bundleId,
              @"MD5 fingerprint": self.fingerprintString,
              @"has identity" : self.identity == NULL ? @"NO" : @"YES",
              @"sandbox" : @(self.sandbox)} description];
}

@end
