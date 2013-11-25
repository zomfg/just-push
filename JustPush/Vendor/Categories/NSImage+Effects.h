//
//  NSImage+Effects.h
//  JustPush
//
//  Created by John Doe on 25/11/13.
//  Copyright (c) 2013 John Doe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Effects)

- (NSImage *) blurry:(CGFloat)blur;
- (NSImage *) darken:(CGFloat)opacity;
- (NSImage *) roundCorners:(CGFloat)radius;

@end
