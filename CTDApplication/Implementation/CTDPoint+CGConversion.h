// CTDPoint+CGConversion:
//     Support for converting between CoreGraphics points (also used by UIKit
//     and elsewhere) and CTDPoints.
//
// Copyright (c) 2014 Michael Hackett. All rights reserved.

#import "CTDUtility/CTDPoint.h"


@interface CTDPoint (CGConversion)

+ (instancetype)fromCGPoint:(CGPoint)cgPoint;
- (CGPoint)asCGPoint;

@end
