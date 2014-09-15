// CALayer+CTDAnimationSupport:
//     Useful additions for implementating animations on layers.
//
// Copyright 2013-4 Michael Hackett. All rights reserved.

#import <QuartzCore/CALayer.h>

@interface CALayer (CTDAnimationSupport)

- (BOOL)isAnimationInFlightForKeyPath:(NSString*)keyPath;

@end
