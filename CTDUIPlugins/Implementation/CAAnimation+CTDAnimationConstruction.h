// CAAnimation+CTDAnimationConstruction:
//     A set of convenience constructors for CAAnimations and their subtypes.
//
// Copyright 2013-4 Michael Hackett. All rights reserved.

#import <QuartzCore/CAAnimation.h>


@interface CAAnimation (CTDAnimationConstruction)

+ (id)animationOfProperty:(NSString*)keyPath
                fromValue:(id)fromValue
                  toValue:(id)toValue;

+ (id)animationOfPathFrom:(CGPathRef)startingPath
                       to:(CGPathRef)endingPath;

+ (id)animationOfPathFrom:(CGPathRef)startingPath
                       to:(CGPathRef)endingPath
             withDuration:(CFTimeInterval)duration;

+ (id)animationHoldingVisible;

+ (id)animationHoldingVisibleWithDuration:(CFTimeInterval)duration;

+ (id)animationOfOpacityFrom:(CGFloat)startingOpacity
                          to:(CGFloat)endingOpacity;

+ (id)animationOfOpacityFrom:(CGFloat)startingOpacity
                          to:(CGFloat)endingOpacity
                withDuration:(CFTimeInterval)duration;

+ (id)animationGroupContaining:(NSArray*)animations;

+ (id)animationGroupContaining:(NSArray*)animations
                  withDuration:(CFTimeInterval)duration;

@end
