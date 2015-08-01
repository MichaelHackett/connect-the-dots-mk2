// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitAnimator.h"

#import "CAAnimation+CTDAnimationConstruction.h"
#import "CALayer+CTDAnimationSupport.h"
#import "CTDAnimationUtils.h"



@implementation CTDUIKitAnimator

+ (void)animateShapeLayer:(CAShapeLayer*)layerToAnimate
         fromStartingPath:(CGPathRef)startingPath
             toEndingPath:(CGPathRef)endingPath
              forDuration:(CGFloat)duration
{
    if ([layerToAnimate isAnimationInFlightForKeyPath:@"hidden"]) {
        startingPath = [(CAShapeLayer*)(layerToAnimate.presentationLayer) path];
    }

    CAAnimation* anim = [CAAnimation animationGroupContaining:@[
        [CAAnimation animationHoldingVisible],
        [CAAnimation animationOfPathFrom:startingPath to:endingPath]
    ] withDuration:duration];
    [layerToAnimate addAnimation:anim forKey:@"hidden"];
}

@end
