// Copyright (c) 2014 Michael Hackett. All rights reserved.

#import "CTDPoint+CGConversion.h"


@implementation CTDPoint (CGConversion)

+ (instancetype)fromCGPoint:(CGPoint)cgPoint
{
    return [self x:cgPoint.x y:cgPoint.y];
}

@end
