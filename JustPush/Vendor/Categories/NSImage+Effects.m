//
//  NSImage+Effects.m
//  JustPush
//
//  Created by John Doe on 25/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import "NSImage+Effects.h"
#import <QuartzCore/QuartzCore.h>

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
    [[NSColor colorWithCalibratedWhite:0.0 alpha:opacity] set];
    NSRectFillUsingOperation(iconRect, NSCompositeSourceAtop);
    [self unlockFocus];
    [self drawInRect:iconRect
            fromRect:iconRect
           operation:NSCompositeSourceOver
            fraction:1.0];
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

@end
