// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDTrialSceneTouchRouter.h"

#import "CTDConnectionTouchInteraction.h"
#import "CTDDelegatingTouchTracker.h"
#import "CTDSelectOnTouchInteraction.h"
#import "CTDTouchResponder.h"
#import "CTDTouchTrackingGroup.h"
#import "ExtensionPoints/CTDTouchMappers.h"
#import "CTDPresentation/CTDDotRenderer.h"

@protocol CTDTrialRenderer; // TEMP!



#pragma mark - Initial delegate touch tracker (private)

typedef void (^CTDDotHitHandler)(id<CTDDotRenderer> hitDotRenderer);


@interface CTDDotDetectionTracker : NSObject <CTDTouchTracker>

- (instancetype)initWithDotsTouchMapper:(id<CTDTouchToElementMapper>)dotsTouchMapper
                   initialTouchLocation:(CTDPoint*)initialTouchLocation
                          dotHitHandler:(CTDDotHitHandler)dotHitHandler;
CTD_NO_DEFAULT_INIT

@end

@implementation CTDDotDetectionTracker
{
    id<CTDTouchToElementMapper> _dotsTouchMapper;
    CTDDotHitHandler _dotHitHandler;
}

- (instancetype)initWithDotsTouchMapper:(id<CTDTouchToElementMapper>)dotsTouchMapper
                   initialTouchLocation:(CTDPoint*)initialTouchLocation
                          dotHitHandler:(CTDDotHitHandler)dotHitHandler
{
    self = [super init];
    if (self) {
        _dotsTouchMapper = dotsTouchMapper;
        _dotHitHandler = [dotHitHandler copy];

        [self CTDDotDetectionTracker_hitTestWithLocation:initialTouchLocation];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    [self CTDDotDetectionTracker_hitTestWithLocation:newPosition];
}

- (void)CTDDotDetectionTracker_hitTestWithLocation:(CTDPoint*)touchLocation
{
    id hitElement = [_dotsTouchMapper elementAtTouchLocation:touchLocation];
    if (hitElement && [hitElement conformsToProtocol:@protocol(CTDDotRenderer)]) {
        _dotHitHandler((id<CTDDotRenderer>)hitElement);
    }
}

@end




#pragma mark - Main class


@implementation CTDTrialSceneTouchRouter
{
    __weak id<CTDTrialRenderer> _trialRenderer;
    id<CTDTouchToElementMapper> _dotsTouchMapper;
    id<CTDTouchToPointMapper> _freeEndMapper;
    id<CTDTouchResponder> _colorCellsTouchResponder;
}

#pragma mark Initialization

- (instancetype)initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer
                      dotsTouchMapper:(id<CTDTouchToElementMapper>)dotsTouchMapper
                        freeEndMapper:(id<CTDTouchToPointMapper>)freeEndMapper
             colorCellsTouchResponder:(id<CTDTouchResponder>)colorCellsTouchResponder
{
    self = [super init];
    if (self) {
        _trialRenderer = trialRenderer;
        _dotsTouchMapper = dotsTouchMapper;
        _freeEndMapper = freeEndMapper;
        _colorCellsTouchResponder = colorCellsTouchResponder;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark CTDTouchResponder protocol

- (id<CTDTouchTracker>)trackerForTouchStartingAt:(CTDPoint*)initialPosition
{
    // When creating the "discriminator" tracker, below, it's possible that the
    // dot-hit block we are supplying will be executed before the tracker's
    // initializer returns (if the initial point is within an object of
    // interest). This may result in changing the main tracker's delegate to
    // a more specific tracker, so we don't want to, on return from the
    // initializer, overwrite this change, switching the tracker's delegate
    // back to this disciminator.
    //
    // To avoid this problem, *another* delegating tracker is created first and
    // used as the main tracker's initial delegate. This second delegator can
    // be created prior to creating the discriminator and assigned to the main
    // delegator before the dot-hit block can execute, so they won't
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
    id<CTDTouchTracker> colorCellsTouchTracker =
        [_colorCellsTouchResponder trackerForTouchStartingAt:initialPosition];
    [initialTrackingGroup addTracker:colorCellsTouchTracker];

    CTDDelegatingTouchTracker* delegatingTracker =
        [[CTDDelegatingTouchTracker alloc]
         initWithInitialDelegate:initialTrackingGroup];

    // local copies for the block's use
    __weak id<CTDTrialRenderer> trialRenderer = _trialRenderer;
    id<CTDTouchToElementMapper> dotsTouchMapper = _dotsTouchMapper;
    id<CTDTouchToPointMapper> freeEndMapper = _freeEndMapper;

    id<CTDTouchTracker> actionDiscriminator =
        [[CTDDotDetectionTracker alloc]
         initWithDotsTouchMapper:_dotsTouchMapper
            initialTouchLocation:initialPosition
                   dotHitHandler:^(id<CTDDotRenderer> hitDotRenderer)
    {
        CTDPoint *initialFreeEndPosition =
            [freeEndMapper pointAtTouchLocation:initialPosition];
        [delegatingTracker changeDelegateTo:
            [[CTDConnectionTouchInteraction alloc]
             initWithTrialRenderer:trialRenderer
                    dotTouchMapper:dotsTouchMapper
                     freeEndMapper:freeEndMapper
                 anchorDotRenderer:hitDotRenderer
            initialFreeEndPosition:initialFreeEndPosition]];
        if ([colorCellsTouchTracker respondsToSelector:@selector(touchWasCancelled)]) {
            [colorCellsTouchTracker touchWasCancelled];
        }
    }];

    [initialTrackingGroup addTracker:actionDiscriminator];

    return delegatingTracker;
}

@end
