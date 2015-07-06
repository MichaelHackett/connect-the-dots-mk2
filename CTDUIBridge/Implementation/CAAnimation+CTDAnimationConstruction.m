// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CAAnimation+CTDAnimationConstruction.h"


// Default animation delegate class. A CAAnimation retains its delegate, so
// the delegate cannot be anything that holds a reference to the view or
// layer to which the animation is applied (such as the view controller).
// But, unlike the usual case, it's perfectly fine to create a new object
// and give it the animation, and it will live exactly as long as needed.
// The current version does nothing in the delegate methods, but if needed,
// this could easily be enhanced to take one or two blocks to provide code
// to run when the animation starts and ends.
//
// Why do we need this? It seems that an animation is *not* immediately
// removed from a layer when it completes *unless* it has a delegate which
// implements `animationDidStop:finished:`. This may be a Core Animation bug,
// and is present at least in iOS 5.1 and 6.1, and probably all versions
// prior to 6.1. iOS 7.x and later have not yet been tested. In any case,
// this work-around should do no harm, even if the behaviour changes in the
// future.

@interface CTDAnimationDelegate : NSObject  // no formal protocol
- (void)animationDidStart:(CAAnimation*)anim;
- (void)animationDidStop:(CAAnimation*)anim finished:(BOOL)flag;
@end

@implementation CTDAnimationDelegate
- (void)animationDidStart:(__unused CAAnimation*)anim {}
- (void)animationDidStop:(__unused CAAnimation*)anim
                finished:(__unused BOOL)flag {}
@end



@implementation CAAnimation (CTDAnimationConstruction)

+ (id)animationOfProperty:(NSString*)keyPath
                fromValue:(id)fromValue
                  toValue:(id)toValue
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.delegate = [[CTDAnimationDelegate alloc] init];  // provide default delegate (see note above)
    return animation;
}

+ (id)animationOfPathFrom:(CGPathRef)startingPath
                       to:(CGPathRef)endingPath
{
    return [self animationOfProperty:@"path"
                           fromValue:(__bridge id)startingPath
                             toValue:(__bridge id)endingPath];
}

+ (id)animationOfPathFrom:(CGPathRef)startingPath
                       to:(CGPathRef)endingPath
             withDuration:(CFTimeInterval)duration
{
    CAAnimation* animation = [self animationOfPathFrom:startingPath
                                                    to:endingPath];
    animation.duration = duration;
    return animation;
}

+ (id)animationHoldingVisible
{
    // iOS 5.1 SDK's #defines of YES and NO require bracketing to use with literal syntax
    return [self animationOfProperty:@"hidden" fromValue:@(NO) toValue:@(NO)];
}

+ (id)animationHoldingVisibleWithDuration:(CFTimeInterval)duration
{
    CAAnimation* animation = [self animationHoldingVisible];
    animation.duration = duration;
    return animation;
}

+ (id)animationOfOpacityFrom:(CGFloat)startingOpacity
                          to:(CGFloat)endingOpacity
{
    return [self animationOfProperty:@"opacity"
                           fromValue:@(startingOpacity)
                             toValue:@(endingOpacity)];
}

+ (id)animationOfOpacityFrom:(CGFloat)startingOpacity
                          to:(CGFloat)endingOpacity
                withDuration:(CFTimeInterval)duration
{
    CAAnimation* animation = [self animationOfOpacityFrom:startingOpacity
                                                       to:endingOpacity];
    animation.duration = duration;
    return animation;
}

+ (id)animationGroupContaining:(NSArray*)animations
{
    CAAnimationGroup* animGroup = [CAAnimationGroup animation];
    animGroup.delegate = [[CTDAnimationDelegate alloc] init];  // default delegate (see note above)
    animGroup.animations = animations;
    return animGroup;
}

+ (id)animationGroupContaining:(NSArray*)animations
                  withDuration:(CFTimeInterval)duration
{
    CAAnimation* animation = [self animationGroupContaining:animations];
    animation.duration = duration;
    return animation;
}

@end
