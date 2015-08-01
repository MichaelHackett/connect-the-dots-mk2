// CTDUIKitAnimator:
//     Application animation effects.
//
// Copyright 2015 Michael Hackett. All rights reserved.


@interface CTDUIKitAnimator : NSObject

+ (void)animateShapeLayer:(CAShapeLayer*)layerToAnimate
         fromStartingPath:(CGPathRef)startingPath
             toEndingPath:(CGPathRef)endingPath
              forDuration:(CGFloat)duration;

@end
