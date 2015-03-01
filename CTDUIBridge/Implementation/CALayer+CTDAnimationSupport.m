// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CALayer+CTDAnimationSupport.h"


@implementation CALayer (CTDAnimationSupport)

- (BOOL)isAnimationInFlightForKeyPath:(NSString*)keyPath
{
    return ([self animationForKey:keyPath] != nil);
}

@end
