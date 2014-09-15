// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDAnimationUtils.h"


void withoutImplicitAnimationDo(CTDAnimationBlock block)
{
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    block();
    [CATransaction commit];
}

void animateWithDuration(double seconds, CTDAnimationBlock block)
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:(CFTimeInterval)seconds];
    block();
    [CATransaction commit];
}
