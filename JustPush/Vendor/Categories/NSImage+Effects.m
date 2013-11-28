//
//  NSImage+Effects.m
//  JustPush
//
//  Created by John Doe on 25/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "NSImage+Effects.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation NSImage (Effects)

- (NSImage *) blurry:(CGFloat)blur {
    if (blur <= 0)
        return self;
    [NSGraphicsContext saveGraphicsState];
    CIImage* inputImage = [CIImage imageWithData:[self TIFFRepresentation]];
    CIFilter* filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setDefaults];
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:@(blur) forKey:@"inputRadius"];
    CIImage* outputImage = [filter valueForKey:@"outputImage"];
    
    NSRect outputImageRect = NSRectFromCGRect([outputImage extent]);
    NSImage* blurredImage = [[NSImage alloc]
                             initWithSize:outputImageRect.size];
    [blurredImage lockFocus];
    [outputImage drawAtPoint:NSZeroPoint fromRect:outputImageRect
                   operation:NSCompositeCopy fraction:1.0];
    [blurredImage unlockFocus];
    [NSGraphicsContext restoreGraphicsState];
    return blurredImage;
}

- (NSImage *) darken:(CGFloat)opacity {
    [NSGraphicsContext saveGraphicsState];
    NSRect iconRect = NSMakeRect(0.0, 0.0, self.size.width, self.size.height);
    [self lockFocus];
    [[NSColor colorWithDeviceWhite:0.0 alpha:opacity] set];
    NSRectFillUsingOperation(iconRect, NSCompositeSourceAtop);
    [self unlockFocus];
    [self lockFocus];
    [self drawAtPoint:NSZeroPoint
            fromRect:iconRect
           operation:NSCompositeSourceOver
            fraction:1.0];
    [self unlockFocus];
    [NSGraphicsContext restoreGraphicsState];
    return self;
}

- (NSImage *) roundCorners:(CGFloat)radius
{
    radius = self.size.width * radius;
    [NSGraphicsContext saveGraphicsState];
    
    NSImage *composedImage = [[NSImage alloc] initWithSize:self.size];
    
    [composedImage lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    
    NSRect imageFrame = NSRectFromCGRect(CGRectMake(0, 0, self.size.width, self.size.height));
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:imageFrame xRadius:radius yRadius:radius];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    
    [self drawAtPoint:NSZeroPoint
             fromRect:imageFrame
            operation:NSCompositeSourceOver
             fraction:1.0];
    
    [composedImage unlockFocus];
    [NSGraphicsContext restoreGraphicsState];
    return composedImage;
}

- (CGImageRef) CGImage {
    return [self CGImageForProposedRect:NULL context:[NSGraphicsContext currentContext] hints:nil];
}

- (NSColor *)averageColor
{
    CGImageRef rawImageRef = [self CGImage];
    
	CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(rawImageRef));
    const UInt8 *rawPixelData = CFDataGetBytePtr(data);
    
    NSUInteger imageHeight = CGImageGetHeight(rawImageRef);
    NSUInteger imageWidth  = CGImageGetWidth(rawImageRef);
    NSUInteger bytesPerRow = CGImageGetBytesPerRow(rawImageRef);
	NSUInteger stride = CGImageGetBitsPerPixel(rawImageRef) / 8;

    unsigned int red   = 0;
    unsigned int green = 0;
    unsigned int blue  = 0;
    
	for (int row = 0; row < imageHeight; row++) {
		const UInt8 *rowPtr = rawPixelData + bytesPerRow * row;
		for (int column = 0; column < imageWidth; column++) {
            red    += rowPtr[0];
            green  += rowPtr[1];
            blue   += rowPtr[2];
			rowPtr += stride;
            
        }
    }
	CFRelease(data);
    
	CGFloat f = 2.0f / (255.0f * imageWidth * imageHeight);
	return [NSColor colorWithRed:f * red  green:f * green blue:f * blue alpha:0.4];
}

@end
