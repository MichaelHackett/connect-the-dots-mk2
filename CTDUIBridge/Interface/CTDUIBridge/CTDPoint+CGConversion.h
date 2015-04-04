// CTDPoint+CGConversion:
//     Support for converting between CoreGraphics points (also used by UIKit
//     and elsewhere) and CTDPoints.
//
// TODO: Migrate this to use a non-application Point type (e.g., VanillaPoint)
//       (See issue #20)
// TODO: I'm not sure if this interface should be public; this is currently
//       needed by UIPlugin code, but we might provide other infrastructure
//       or support interfaces to allow plugins to work with the vanilla point
//       type mentioned above.
//
// Copyright (c) 2014-5 Michael Hackett. All rights reserved.

#import "CTDUtility/CTDPoint.h"


@interface CTDPoint (CGConversion)

+ (instancetype)fromCGPoint:(CGPoint)cgPoint;
- (CGPoint)asCGPoint;

@end
