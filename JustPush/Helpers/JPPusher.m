//
//  JPPusher.m
//  JustPush
//
//  Created by Sergio Kunats on 11/19/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "ioSock.h"
#import "JPPusher.h"
#import "JPNotification.h"
#import "JPCertificate.h"
#import "JPPayload.h"
#import "JPDeviceToken.h"

// https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/CommunicatingWIthAPS.html#//apple_ref/doc/uid/TP40008194-CH101-SW1

static const char* kJPPushRemoteServer          = "gateway.push.apple.com";
static const char* kJPPushRemoteSandboxServer   = "gateway.sandbox.push.apple.com";
static const int   kJPPushRemotePort            = 2195;

static const NSUInteger kJPPushMessageMaxLength = 293; // 1(cmd byte) + 2(token length) + 32(token) + 2(payload length) + 256(payload)

@interface JPPusher ()

@property (nonatomic, assign) otSocket       socket;
@property (nonatomic, assign) SSLContextRef  context;
@property (nonatomic, strong) JPNotification *notification;

@end

@implementation JPPusher

- (JPPusher *) initWithNotification:(JPNotification *)notification {
    if ((self = [super init]))
        self.notification = notification;
    return self;
}

+ (JPPusher *) pusherWithNotification:(JPNotification *)notification {
    return [[[self class] alloc] initWithNotification:notification];
}

- (const char*) pushServerHostname {
    if (self.notification.sandbox)
        return kJPPushRemoteSandboxServer;
    return kJPPushRemoteServer;
}

- (void) SSLError:(NSString*)func SSLResult:(OSStatus)result {
    NSLog(@"%@(): [%s] - %s", func, (char *)GetMacOSStatusErrorString(result), (char *)GetMacOSStatusCommentString(result));
}

- (BOOL) connect {
	OSStatus result;
	PeerSpec peer;

	result = MakeServerConnection(self.pushServerHostname, kJPPushRemotePort, 1, &_socket, &peer);
    if (result != errSecSuccess) {
        [self SSLError:@"MakeServerConnection" SSLResult:result];
        return NO;
    }

	result = SSLNewContext(false, &_context);
    if (result != errSecSuccess) {
        [self SSLError:@"SSLNewContext" SSLResult:result];
        return NO;
    }

	result = SSLSetIOFuncs(_context, SocketRead, SocketWrite);
    if (result != errSecSuccess) {
        [self SSLError:@"SSLSetIOFuncs" SSLResult:result];
        return NO;
    }

	result = SSLSetConnection(_context, (SSLConnectionRef)_socket);
    if (result != errSecSuccess) {
        [self SSLError:@"SSLSetConnection" SSLResult:result];
        return NO;
    }

	result = SSLSetPeerDomainName(_context, self.pushServerHostname, strlen(self.pushServerHostname));
    if (result != errSecSuccess) {
        [self SSLError:@"SSLSetPeerDomainName" SSLResult:result];
        return NO;
    }

    SecIdentityRef identity = self.notification.certificate.identity;
	CFArrayRef certificates = CFArrayCreate(NULL, (const void **)&identity, 1, NULL);
	result = SSLSetCertificate(_context, certificates);
    CFRelease(certificates);
    if (result != errSecSuccess) {
        [self SSLError:@"SSLSetCertificate" SSLResult:result];
        return NO;
    }

	do {
		result = SSLHandshake(_context);
	} while (result == errSSLWouldBlock);

    if (result != errSecSuccess)
        [self SSLError:@"SSLHandshake" SSLResult:result];
	return result == errSecSuccess;
}

- (void) disconnect {
    if (self.context != NULL) {
        SSLClose(_context);
        close((int)_socket);
        SSLDisposeContext(_context);
    }
    self.context = NULL;
}

- (void) dealloc {
    [self disconnect];
}

- (BOOL) sendSingle:(JPPayload *)payload toDevice:(JPDeviceToken *)deviceToken {
	if (payload == nil || deviceToken == nil)
		return NO;
    NSData *tokenData = deviceToken.tokenData;
    if (tokenData == nil || tokenData.length < 1)
        return NO;
	char *deviceTokenBinary  = (char *)[tokenData bytes];
	char *payloadBinary      = (char *)[payload.JSON UTF8String];
	size_t payloadLength     = strlen(payloadBinary);
    size_t deviceTokenLength = tokenData.length;

	char message[kJPPushMessageMaxLength];
	char *pointer = message;
	uint16_t networkTokenLength   = htons(deviceTokenLength);
	uint16_t networkPayloadLength = htons(payloadLength);

    uint8_t command = 0;
	memcpy(pointer, &command, sizeof(command));
	pointer += sizeof(command);
	memcpy(pointer, &networkTokenLength, sizeof(networkTokenLength));
	pointer += sizeof(networkTokenLength);
	memcpy(pointer, deviceTokenBinary, deviceTokenLength);
	pointer += deviceTokenLength;
	memcpy(pointer, &networkPayloadLength, sizeof(networkPayloadLength));
	pointer += sizeof(networkPayloadLength);
	memcpy(pointer, payloadBinary, payloadLength);
	pointer += payloadLength;

	size_t processed = 0;
	OSStatus result = SSLWrite(self.context, &message, (pointer - message), &processed);
    if (result != errSecSuccess)
        [self SSLError:@"SSLWrite" SSLResult:result];
    return result == errSecSuccess;
}

- (BOOL) push {
    if (self.context == NULL && ![self connect])
        return NO;
    for (JPDeviceToken* deviceToken in self.notification.tokens)
        [self sendSingle:self.notification.payload toDevice:deviceToken];
    return YES;
}

@end
