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

static otSocket _socket       = -1;
static SSLContextRef _context = NULL;

@implementation JPPusher

+ (const char*) pushServerHostname:(BOOL)sandbox {
    if (sandbox)
        return "gateway.sandbox.push.apple.com";
    return "gateway.push.apple.com";
}

+ (void) SSLDebug:(NSString*)func SSLResult:(OSStatus)result {
    NSLog(@"%@(): [%s] - %s", func, (char *)GetMacOSStatusErrorString(result), (char *)GetMacOSStatusCommentString(result));
}

+ (BOOL) connect:(JPNotification *)notification {
	OSStatus result;
	PeerSpec peer;
    const char* applePushServer = [self pushServerHostname:notification.sandbox];

	result = MakeServerConnection(applePushServer, 2195, 1, &_socket, &peer);
    [self SSLDebug:@"MakeServerConnection" SSLResult:result];

	result = SSLNewContext(false, &_context);
    [self SSLDebug:@"SSLNewContext" SSLResult:result];
    if (result != errSecSuccess || _context == NULL)
        return NO;

	result = SSLSetIOFuncs(_context, SocketRead, SocketWrite);
    [self SSLDebug:@"SSLSetIOFuncs" SSLResult:result];

	result = SSLSetConnection(_context, (SSLConnectionRef)_socket);
    [self SSLDebug:@"SSLSetConnection" SSLResult:result];

	result = SSLSetPeerDomainName(_context, applePushServer, strlen(applePushServer));
    [self SSLDebug:@"SSLSetPeerDomainName" SSLResult:result];

    SecIdentityRef identity = notification.certificate.identity;
	CFArrayRef certificates = CFArrayCreate(NULL, (const void **)&identity, 1, NULL);
	result = SSLSetCertificate(_context, certificates);
    [self SSLDebug:@"SSLSetCertificate" SSLResult:result];
	CFRelease(certificates);

	do {
		result = SSLHandshake(_context);
        NSLog(@"SSLHandshake(): %d", result);
        [self SSLDebug:@"SSLHandshake" SSLResult:result];
	} while (result == errSSLWouldBlock);
	return result == errSecSuccess;
}

+ (void) disconnect {
    if (_context != NULL) {
        SSLClose(_context);
        close((int)_socket);
        SSLDisposeContext(_context);
    }
}

+ (void) send:(JPPayload *)payload toDevice:(JPDeviceToken *)deviceToken {
	// Validate input.
	if (payload == nil)
		return;
    if (NO && ![deviceToken.token rangeOfString:@" "].length)
    {
        //put in spaces in device token
        NSMutableString* tempString =  [NSMutableString stringWithString:deviceToken.token];
        int offset = 0;
        for (int i = 0; i < tempString.length; i++)
        {
            if (i%8 == 0 && i != 0 && i+offset < tempString.length-1)
            {
                //NSLog(@"i = %d + offset[%d] = %d", i, offset, i+offset);
                [tempString insertString:@" " atIndex:i+offset];
                offset++;
            }
        }
        NSLog(@" device token string after adding spaces = '%@'", tempString);
//        deviceToken.token = tempString;
    }

	// Convert string into device token data.
	NSMutableData *deviceTokenData = [NSMutableData data];
	unsigned value;
	NSScanner *scanner = [NSScanner scannerWithString:deviceToken.token];
	while(![scanner isAtEnd]) {
		[scanner scanHexInt:&value];
        //NSLog(@"scanned value %x", value);
		value = htonl(value);
		[deviceTokenData appendBytes:&value length:sizeof(value)];
	}
	NSLog(@"device token data %@, length = %ld", deviceTokenData, deviceTokenData.length);
	// Create C input variables.
	char *deviceTokenBinary = (char *)[deviceTokenData bytes];
	char *payloadBinary = (char *)[payload.JSON UTF8String];
	size_t payloadLength = strlen(payloadBinary);

	// Define some variables.
	uint8_t command = 0;
	char message[293];
	char *pointer = message;
	uint16_t networkTokenLength = htons(32);
	uint16_t networkPayloadLength = htons(payloadLength);

	// Compose message.
	memcpy(pointer, &command, sizeof(uint8_t));
	pointer += sizeof(uint8_t);
	memcpy(pointer, &networkTokenLength, sizeof(uint16_t));
	pointer += sizeof(uint16_t);
	memcpy(pointer, deviceTokenBinary, 32);
	pointer += 32;
	memcpy(pointer, &networkPayloadLength, sizeof(uint16_t));
	pointer += sizeof(uint16_t);
	memcpy(pointer, payloadBinary, payloadLength);
	pointer += payloadLength;

	NSLog(@"pointer - message- %ld", (pointer -message));
	// Send message over SSL.
	size_t processed = 0;
	OSStatus result = SSLWrite(_context, &message, (pointer - message), &processed);// NSLog(@"SSLWrite(): %d %d", result, processed);
	NSLog(@"SSLWrite(): [%s]- %s", (char *)GetMacOSStatusErrorString(result), (char *)GetMacOSStatusCommentString(result));
    NSLog(@"SSLWrite(): %d %ld", result, processed);
}

+ (void) push:(JPNotification *)notification {
    [self disconnect];
    if ([self connect:notification]) {
        NSLog(@"CONNECT SUCCESS");
        for (JPDeviceToken* deviceToken in notification.tokens)
            [self send:notification.payload toDevice:deviceToken];
    } else
        NSLog(@"CONNECT FAIL :(");
    [self disconnect];
}

@end
