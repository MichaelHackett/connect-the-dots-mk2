// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDTrialSceneTouchRouter.h"

#import "CTDConnectionTouchInteraction.h"
#import "CTDDelegatingTouchTracker.h"
#import "CTDSelectOnTouchInteraction.h"
#import "CTDTargetRenderer.h"
#import "CTDTouchMapper.h"
#import "CTDTouchResponder.h"
#import "CTDTouchTrackingGroup.h"
#import "CTDTrialRenderer.h"



#pragma mark - Initial delegate touch tracker (private)

typedef void (^CTDTargetHitHandler)(id<CTDTargetRenderer> hitTargetView);


@interface CTDTargetDetectionTracker : NSObject <CTDTouchTracker>

- (instancetype)initWithTargetsTouchMapper:(id<CTDTouchMapper>)targetsTouchMapper
                      initialTouchLocation:(CTDPoint*)initialTouchLocation
                          targetHitHandler:(CTDTargetHitHandler)targetHitHandler;
CTD_NO_DEFAULT_INIT

@end

@implementation CTDTargetDetectionTracker
{
    id<CTDTouchMapper> _targetsTouchMapper;
    CTDTargetHitHandler _targetHitHandler;
}

- (instancetype)initWithTargetsTouchMapper:(id<CTDTouchMapper>)targetsTouchMapper
                     initialTouchLocation:(CTDPoint*)initialTouchLocation
                         targetHitHandler:(void(^)(id<CTDTargetRenderer> hitTargetView))targetHitHandler
{
    self = [super init];
    if (self) {
        _targetsTouchMapper = targetsTouchMapper;
        _targetHitHandler = [targetHitHandler copy];

        [self CTDTargetDetectionTracker_hitTestWithLocation:initialTouchLocation];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    [self CTDTargetDetectionTracker_hitTestWithLocation:newPosition];
}

- (void)CTDTargetDetectionTracker_hitTestWithLocation:(CTDPoint*)touchLocation
{
    id hitElement = [_targetsTouchMapper elementAtTouchLocation:touchLocation];
    if (hitElement && [hitElement conformsToProtocol:@protocol(CTDTargetRenderer)]) {
        _targetHitHandler((id<CTDTargetRenderer>)hitElement);
    }
}

@end




#pragma mark - Main class


@implementation CTDTrialSceneTouchRouter
{
    __weak id<CTDTrialRenderer> _trialRenderer;
    id<CTDTouchMapper> _targetsTouchMapper;
    id<CTDTouchResponder> _colorButtonsTouchResponder;
}

#pragma mark - Initialization

- (instancetype)initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer
                   targetsTouchMapper:(id<CTDTouchMapper>)targetsTouchMapper
           colorButtonsTouchResponder:(id<CTDTouchResponder>)colorButtonsTouchResponder
{
    self = [super init];
    if (self) {
        _trialRenderer = trialRenderer;
        _targetsTouchMapper = targetsTouchMapper;
        _colorButtonsTouchResponder = colorButtonsTouchResponder;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark - CTDTouchResponder protocol

- (id<CTDTouchTracker>)trackerForTouchStartingAt:(CTDPoint*)initialPosition
{
    // When creating the "discriminator" tracker, below, it's possible that the
    // target-hit block we are supplying will be executed before the tracker's
    // initializer returns (if the initial point is within an object of
    // interest). This may result in changing the main tracker's delegate to
    // a more specific tracker, so we don't want to, on return from the
    // initializer, overwrite this change, switching the tracker's delegate
    // back to this disciminator.
    //
    // To avoid this problem, *another* delegating tracker is created first and
    // used as the main tracker's initial delegate. This second delegator can
    // be created prior to creating the discriminator and assigned to the main
    // delegator before the target-hit block can execute, so they won't
    // interfere. The second delegate delegates only to the discriminator (this
    // is never changed anywhere else, so there's no race condition to be
    // concerned about), and it drops away once the main tracker has been
    // redirected to some other specific tracker. If the main delegate is
    // changed before the discriminator's initializer returns, the initial
    // tracker is simply never used.
    //
    // It's a little bit "clever" (tricky), but it solves the problem fairly
    // simply, without resorting to delayed execution or locking. And if it
    // weren't for the number of arguments required for the initializers below,
    // it would actually be a pretty short block of code (7 statements plus 1
    // in the block).

    CTDTouchTrackingGroup* initialTrackingGroup =
        [[CTDTouchTrackingGroup alloc] init];
    id<CTDTouchTracker> colorButtonsTouchTracker =
        [_colorButtonsTouchResponder trackerForTouchStartingAt:initialPosition];
    [initialTrackingGroup addTracker:colorButtonsTouchTracker];

    CTDDelegatingTouchTracker* delegatingTracker =
        [[CTDDelegatingTouchTracker alloc]
         initWithInitialDelegate:initialTrackingGroup];

    // local copies for the block's use
    __weak id<CTDTrialRenderer> trialRenderer = _trialRenderer;
    id<CTDTouchMapper> targetsTouchMapper = _targetsTouchMapper;

    id<CTDTouchTracker> actionDiscriminator =
        [[CTDTargetDetectionTracker alloc]
         initWithTargetsTouchMapper:_targetsTouchMapper
               initialTouchLocation:initialPosition
                   targetHitHandler:^(id<CTDTargetRenderer> hitTargetView)
    {
        [delegatingTracker changeDelegateTo:
            [[CTDConnectionTouchInteraction alloc]
             initWithTrialRenderer:trialRenderer
                 targetTouchMapper:targetsTouchMapper
                  anchorTargetView:hitTargetView
            initialFreeEndPosition:initialPosition]];
        if ([colorButtonsTouchTracker respondsToSelector:@selector(touchWasCancelled)]) {
            [colorButtonsTouchTracker touchWasCancelled];
        }
    }];

    [initialTrackingGroup addTracker:actionDiscriminator];

    return delegatingTracker;
}

@end
