// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDTrialSceneTouchRouter.h"

#import "CTDConnectionTouchInteraction.h"
#import "CTDDelegatingTouchTracker.h"
#import "CTDSelectOnTouchInteraction.h"
#import "CTDTouchResponder.h"
#import "CTDTouchTrackingGroup.h"
#import "Ports/CTDTouchMappers.h"
#import "Ports/CTDTrialEditor.h"



#pragma mark - Initial delegate touch tracker (private)

typedef void (^CTDDotHitHandler)(CTDPoint* touchPosition, id hitDotId);


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
    if (self)
    {
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

// TODO: Turn into a block in an ivar
- (void)CTDDotDetectionTracker_hitTestWithLocation:(CTDPoint*)touchLocation
{
    id hitElementId = [_dotsTouchMapper idOfElementAtTouchLocation:touchLocation];
    if (hitElementId)
    {
        _dotHitHandler(touchLocation, hitElementId);
    }
}

@end




#pragma mark - Main class


@implementation CTDTrialSceneTouchRouter


#pragma mark Initialization

- (id)init
{
    self = [super init];
    if (self)
    {
        _trialEditor = nil;
        _dotsTouchMapper = nil;
        _freeEndMapper = nil;
        _colorCellsTouchResponder = nil;
    }
    return self;
}

- (instancetype)initWithTrialRenderer:(__unused id<CTDTrialRenderer>)trialRenderer
                      dotsTouchMapper:(id<CTDTouchToElementMapper>)dotsTouchMapper
                        freeEndMapper:(id<CTDTouchToPointMapper>)freeEndMapper
             colorCellsTouchResponder:(id<CTDTouchResponder>)colorCellsTouchResponder
{
    self = [super init];
    if (self)
    {
        _dotsTouchMapper = dotsTouchMapper;
        _freeEndMapper = freeEndMapper;
        _colorCellsTouchResponder = colorCellsTouchResponder;
    }
    return self;
}



#pragma mark CTDTouchResponder protocol


- (id<CTDTouchTracker>)trackerForTouchStartingAt:(CTDPoint*)initialPosition
{
    // When creating the "discriminator" tracker, below, it's possible that the
    // dot-hit block we are supplying will be executed before the tracker's
    // initializer returns (if the initial point is within an object of
    // interest). This may result in changing the main tracker's delegate to
    // a more specific tracker, so we don't want to overwrite this change on
    // return from the initializer, switching the tracker's delegate back to
    // this disciminator.
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
    // it would actually be a pretty short block of code.

    CTDTouchTrackingGroup* initialTrackingGroup = [[CTDTouchTrackingGroup alloc] init];

    ctd_strongify(self.colorCellsTouchResponder, colorCellsTouchResponder);
    id<CTDTouchTracker> colorCellsTouchTracker =
        [colorCellsTouchResponder trackerForTouchStartingAt:initialPosition];
    if (colorCellsTouchTracker)
    {
        [initialTrackingGroup addTracker:colorCellsTouchTracker];
    }

    CTDDelegatingTouchTracker* delegatingTracker =
        [[CTDDelegatingTouchTracker alloc]
         initWithInitialDelegate:initialTrackingGroup];

    ctd_strongify(self.dotsTouchMapper, dotsTouchMapper);
    ctd_weakify(self, weakSelf);

    id<CTDTouchTracker> actionDiscriminator =
        [[CTDDotDetectionTracker alloc]
         initWithDotsTouchMapper:dotsTouchMapper
            initialTouchLocation:initialPosition
                   dotHitHandler:^(CTDPoint* touchPosition, id hitDotId)
    {
        ctd_strongify(weakSelf, strongSelf);
        ctd_strongify(strongSelf.trialEditor, trialEditor);
        id<CTDTrialStepEditor> trialStepEditor = [trialEditor editorForCurrentStep];

        // Don't check for dot hits if proper color isn't selected.
        if (![trialStepEditor isConnectionAllowed]) { return; }

        if ([hitDotId isEqual:[trialStepEditor startingDotId]]) {
            id<CTDTrialStepConnectionEditor> connectionEditor =
                [trialStepEditor editorForNewConnection];
            [delegatingTracker changeDelegateTo:
                [[CTDConnectionTouchInteraction alloc]
                 initWithConnectionEditor:connectionEditor
                           dotTouchMapper:strongSelf.dotsTouchMapper
                            freeEndMapper:strongSelf.freeEndMapper
                            startingDotId:hitDotId
                     initialTouchPosition:touchPosition]];
            if ([colorCellsTouchTracker respondsToSelector:@selector(touchWasCancelled)]) {
                [colorCellsTouchTracker touchWasCancelled];
            }
        }
    }];

    if (actionDiscriminator)
    {
        [initialTrackingGroup addTracker:actionDiscriminator];
    }

    return delegatingTracker;
}

@end
