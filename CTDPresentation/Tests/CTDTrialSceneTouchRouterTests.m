// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTrialSceneTouchRouter.h"

#import "CTDTargetConnectionView.h"
#import "CTDTargetRenderer.h"
#import "CTDTouchable.h"
#import "CTDTouchMapper.h"
#import "CTDTrialRenderer.h"
#import "CTDUtility/CTDPoint.h"
#import <XCTest/XCTest.h>



#define TARGET_1_CENTER [[CTDPoint alloc] initWithX:40 y:96]
#define POINT_INSIDE_TARGET_1 [[CTDPoint alloc] initWithX:45 y:99]
#define ANOTHER_POINT_INSIDE_TARGET_1 [[CTDPoint alloc] initWithX:47 y:95]
#define POINT_OUTSIDE_TARGETS [[CTDPoint alloc] initWithX:22 y:70]
#define ANOTHER_POINT_OUTSIDE_TARGETS [[CTDPoint alloc] initWithX:140 y:250]



//
// Note: No attempt has been made to make any of these test-support classes
// KVO-compliant. The properties exposed are usually read-only from the
// outside, but the values do change; there just isn't any KVO notification
// when those changes occur. Tests usually read the property values just
// once and have no need to follow changes. (They don't care what happens
// before or after the check.) So adding KVO support would be a waste of
// time, and probably never missed. Nonetheless, this serves as a reminder
// of the status and reasoning, should the question ever come up.
//

@interface CTDFakeTargetRenderer : NSObject <CTDTargetRenderer, CTDTouchable>

@property (copy, readonly, nonatomic) CTDPoint* centerPosition;
@property (assign, readonly, nonatomic, getter=isSelected) BOOL selected;

@end

@implementation CTDFakeTargetRenderer

- (instancetype)initWithCenterPosition:(CTDPoint*)centerPosition
{
    self = [super init];
    if (self) {
        _centerPosition = [centerPosition copy];
        _selected = NO;
    }
    return self;
}

- (void)showSelectionIndicator { _selected = YES; }
- (void)hideSelectionIndicator { _selected = NO; }
- (CTDPoint*)connectionPoint { return self.centerPosition; }
- (BOOL)containsTouchLocation:(__unused CTDPoint*)touchLocation { return NO; }

@end





@interface CTDRecordingTargetConnectionView : NSObject <CTDTargetConnectionView>

@property (copy, readonly, nonatomic) CTDPoint* firstEndpointPosition;
@property (copy, readonly, nonatomic) CTDPoint* secondEndpointPosition;
@property (assign, readonly, nonatomic, getter=wasInvalidated) BOOL invalidated;

- (instancetype)initWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                       secondEndpointPosition:(CTDPoint*)secondEndpointPosition;
@end

@implementation CTDRecordingTargetConnectionView
- (instancetype)initWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                       secondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    self = [super init];
    if (self) {
        _firstEndpointPosition = [firstEndpointPosition copy];
        _secondEndpointPosition = [secondEndpointPosition copy];
    }
    return self;
}

- (void)setFirstEndpointPosition:(CTDPoint*)firstEndpointPosition {
    _firstEndpointPosition = [firstEndpointPosition copy];
}

- (void)setSecondEndpointPosition:(CTDPoint*)secondEndpointPosition {
    _secondEndpointPosition = [secondEndpointPosition copy];
}

- (void)invalidate {
    _invalidated = YES;
}

@end





@interface CTDRecordingTrialRenderer : NSObject <CTDTrialRenderer>

@property (strong, readonly, nonatomic) NSArray* targetViewsCreated;
@property (strong, readonly, nonatomic) NSArray* targetConnectionViewsCreated;

@end

@implementation CTDRecordingTrialRenderer
{
    NSMutableArray* _targetViewsCreated;
    NSMutableArray* _targetConnectionViewsCreated;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _targetViewsCreated = [[NSMutableArray alloc] init];
        _targetConnectionViewsCreated = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray*)targetViewsCreated
{
    return [_targetViewsCreated copy];
}

- (NSArray*)targetConnectionViewsCreated
{
    return [_targetConnectionViewsCreated copy];
}

- (id<CTDTargetRenderer, CTDTouchable>)newTargetViewCenteredAt:(CTDPoint*)centerPosition
{
    id newTargetView = [[CTDFakeTargetRenderer alloc]
                        initWithCenterPosition:centerPosition];
    [_targetViewsCreated addObject:newTargetView];
    return newTargetView;
}

- (id<CTDTargetConnectionView>)
      newTargetConnectionViewWithFirstEndpointPosition:
          (CTDPoint*)firstEndpointPosition
      secondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    id newTargetConnectionView = [[CTDRecordingTargetConnectionView alloc]
                                  initWithFirstEndpointPosition:firstEndpointPosition
                                  secondEndpointPosition:secondEndpointPosition];
    [_targetConnectionViewsCreated addObject:newTargetConnectionView];
    return newTargetConnectionView;
}

@end




static CTDFakeTargetRenderer* target1;


@interface CTDFakeTouchMapper : NSObject <CTDTouchMapper>
@end

@implementation CTDFakeTouchMapper

- (id)elementAtTouchLocation:(CTDPoint*)touchLocation
{
    if ([touchLocation isEqual:POINT_INSIDE_TARGET_1] ||
        [touchLocation isEqual:ANOTHER_POINT_INSIDE_TARGET_1])
    {
        return target1;
    }
    return nil;
}

@end




@interface CTDTrialSceneTouchRouterBaseTestCase : XCTestCase
@property (strong, readonly, nonatomic) CTDTrialSceneTouchRouter* subject;
@property (strong, readonly, nonatomic) CTDRecordingTrialRenderer* trialRenderer;
@property (strong, readonly, nonatomic) CTDFakeTouchMapper* touchMapper;
@end

@implementation CTDTrialSceneTouchRouterBaseTestCase

- (void)setUp
{
    [super setUp];

    target1 = [[CTDFakeTargetRenderer alloc] initWithCenterPosition:TARGET_1_CENTER];

    _trialRenderer = [[CTDRecordingTrialRenderer alloc] init];
    _touchMapper = [[CTDFakeTouchMapper alloc] init];
    _subject = [[CTDTrialSceneTouchRouter alloc]
                initWithTrialRenderer:_trialRenderer
                 targetsTouchMapper:_touchMapper];
}

- (void)tearDown
{
    _subject = nil;
    _touchMapper = nil;
    _trialRenderer = nil;

    target1 = nil;

    [super tearDown];
}

- (NSArray*)selectedTargets
{
    NSMutableArray* selectedTargets = [[NSMutableArray alloc] init];
    if ([target1 isSelected]) { [selectedTargets addObject:target1]; }
    return selectedTargets;
}

@end



@interface CTDTrialSceneTouchTrackerBaseTestCase
    : CTDTrialSceneTouchRouterBaseTestCase

@property (strong, nonatomic) id<CTDTouchTracker> touchTracker;
@end

@implementation CTDTrialSceneTouchTrackerBaseTestCase

- (void)tearDown
{
    self.touchTracker = nil;
    [super tearDown];
}

@end


@interface CTDTrialSceneTouchTrackerStartingOutsideAnyTargetTestCase
    : CTDTrialSceneTouchTrackerBaseTestCase
@end

@implementation CTDTrialSceneTouchTrackerStartingOutsideAnyTargetTestCase

- (void)setUp
{
    [super setUp];
    self.touchTracker = [self.subject trackerForTouchStartingAt:POINT_OUTSIDE_TARGETS];
}

- (void)testThatNoTargetBecomesSelectedImmediately
{
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

- (void)testThatNoConnectionsAreStartedInitially
{
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 0u,
                   @"expected connection count to be 0");
}

- (void)testThatNoTargetBecomesSelectedWhenTheTouchMovesWithoutEnteringAnyTarget
{
    [self.touchTracker touchDidMoveTo:ANOTHER_POINT_OUTSIDE_TARGETS];
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

- (void)testThatNoConnectionIsStartedWhenTheTouchMovesWithoutEnteringAnyTarget
{
    [self.touchTracker touchDidMoveTo:ANOTHER_POINT_OUTSIDE_TARGETS];
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 0u,
                   @"expected connection count to be 0");
}

- (void)testThatTheTargetBecomesSelectedWhenTheTouchMovesOntoATarget
{
    [self.touchTracker touchDidMoveTo:POINT_INSIDE_TARGET_1];
    XCTAssertTrue([target1 isSelected], @"expected target to be selected");
}

- (void)testThatNoOtherTargetBecomesSelectedWhenTheTouchMovesOntoATarget
{
    [self.touchTracker touchDidMoveTo:POINT_INSIDE_TARGET_1];
    XCTAssertEqual([[self selectedTargets] count], 1u,
                   @"expected number of selected targets to be exactly 1");
}

- (void)testThatAConnectionIsStartedWhenTheTouchMovesOntoATarget
{
    [self.touchTracker touchDidMoveTo:POINT_INSIDE_TARGET_1];
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 1u,
                   @"expected connection count to be 1");
}

- (void)testThatNoTargetBecomesSelectedWhenTheTouchEnds
{
    [self.touchTracker touchDidEnd];
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

- (void)testThatNoTargetBecomesSelectedWhenTheTouchIsCancelled
{
    [self.touchTracker touchWasCancelled];
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

@end



@interface CTDTrialSceneTouchTrackerStartingInsideATargetTestCase
    : CTDTrialSceneTouchTrackerBaseTestCase
@end

@implementation CTDTrialSceneTouchTrackerStartingInsideATargetTestCase

- (void)setUp
{
    [super setUp];
    self.touchTracker = [self.subject trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
}

- (CTDRecordingTargetConnectionView*)activeConnection
{
    return [self.trialRenderer.targetConnectionViewsCreated firstObject];
}



// --- Initial conditions ---

- (void)testThatTheTargetBecomesSelectedImmediately
{
    XCTAssertTrue([target1 isSelected], @"expected target to be selected");
}

- (void)testThatNoOtherTargetsBecomeSelectedImmediately
{
    XCTAssertEqual([[self selectedTargets] count], 1u,
                   @"expected number of selected targets to be exactly 1");
}

- (void)testThatAConnectionIsStartedImmediately
{
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 1u,
                   @"expected connection count to be 1");
}

- (void)testThatTheFirstEndpointOfTheConnectionIsAnchoredToTheTargetConnectionPoint
{
    XCTAssertEqualObjects([self activeConnection].firstEndpointPosition,
                          [target1 connectionPoint],
                          @"expected connection's second endpoint to equal the target's connection point");
}

- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPosition
{
    XCTAssertEqualObjects([self activeConnection].secondEndpointPosition,
                          POINT_INSIDE_TARGET_1,
                          @"expected connection's second endpoint to equal the touch position");
}



// --- Touch moves without leaving initial target ---

- (void)testThatTheInitialTargetRemainsSelectedWhenTheTouchMovesWithoutLeavingTheInitialTarget
{
    [self.touchTracker touchDidMoveTo:ANOTHER_POINT_INSIDE_TARGET_1];
    XCTAssertTrue([target1 isSelected], @"expected target to be selected");
}

- (void)testThatNoOtherTargetBecomesSelectedWhenTheTouchMovesWithoutLeavingTheInitialTarget
{
    [self.touchTracker touchDidMoveTo:ANOTHER_POINT_INSIDE_TARGET_1];
    XCTAssertEqual([[self selectedTargets] count], 1u,
                   @"expected number of selected targets to be exactly 1");
}

- (void)testThatTheFirstEndpointOfTheConnectionRemainsAnchoredToTheInitialTargetConnectionPointWhenTheTouchMovesWithoutLeavingTheInitialTarget
{
    [self.touchTracker touchDidMoveTo:ANOTHER_POINT_INSIDE_TARGET_1];
    XCTAssertEqualObjects([self activeConnection].firstEndpointPosition,
                          [target1 connectionPoint],
                          @"expected connection's second endpoint to equal the target's connection point");
}

- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPositionWhenTheTouchMovesWithoutLeavingTheInitialTarget
{
    [self.touchTracker touchDidMoveTo:ANOTHER_POINT_INSIDE_TARGET_1];
    XCTAssertEqualObjects([self activeConnection].secondEndpointPosition,
                           ANOTHER_POINT_INSIDE_TARGET_1,
                           @"expected connection's second endpoint to equal the touch position");
}

- (void)testThatNoNewConnectionIsStartedWhenTheTouchMovesWithoutLeavingTheInitialTarget
{
    [self.touchTracker touchDidMoveTo:ANOTHER_POINT_INSIDE_TARGET_1];
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 1u,
                   @"expected connection count to be 1");
}



// --- Touch moves off initial target ---

- (void)testThatTheInitialTargetRemainsSelectedWhenTheTouchMovesOff
{
    [self.touchTracker touchDidMoveTo:POINT_OUTSIDE_TARGETS];
    XCTAssertTrue([target1 isSelected], @"expected target to be selected");
}

- (void)testThatNoOtherTargetBecomesSelectedWhenTheTouchMovesOffTheInitialTarget
{
    [self.touchTracker touchDidMoveTo:POINT_OUTSIDE_TARGETS];
    XCTAssertEqual([[self selectedTargets] count], 1u,
                   @"expected number of selected targets to be exactly 1");
}

- (void)testThatTheFirstEndpointOfTheConnectionRemainsAnchoredToTheInitialTargetConnectionPointWhenTheTouchMovesOffTheInitialTarget
{
    [self.touchTracker touchDidMoveTo:ANOTHER_POINT_INSIDE_TARGET_1];
    XCTAssertEqualObjects([self activeConnection].firstEndpointPosition,
                          [target1 connectionPoint],
                          @"expected connection's second endpoint to equal the target's connection point");
}

- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPositionWhenTheTouchMovesOffTheInitialTarget
{
    [self.touchTracker touchDidMoveTo:POINT_OUTSIDE_TARGETS];
    XCTAssertEqualObjects([self activeConnection].secondEndpointPosition,
                          POINT_OUTSIDE_TARGETS,
                          @"expected connection's second endpoint to equal the touch position");
}

- (void)testThatNoNewConnectionIsStartedWhenTheTouchMovesOffTheInitialTarget
{
    [self.touchTracker touchDidMoveTo:POINT_OUTSIDE_TARGETS];
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 1u,
                   @"expected connection count to be exactly 1");
}



// --- Touch ends ---

- (void)testThatTheInitialTargetBecomesUnselectedIfTheTouchEndsWhileWithinTheTarget
{
    [self.touchTracker touchDidEnd];
    XCTAssertFalse([target1 isSelected], @"expected target to be unselected");
}

- (void)testThatTheConnectionIsDiscardedIfTheTouchEndsWhileWithinTheTarget
{
    [self.touchTracker touchDidEnd];

}



// --- Touch is cancelled ---

- (void)testThatTheInitialTargetBecomesUnselectedIfTheTouchIsCancelledWhileWithinTheTarget
{
    [self.touchTracker touchWasCancelled];
    XCTAssertFalse([target1 isSelected], @"expected target to be unselected");
}

- (void)testThatTheConnectionIsDiscardedIfTheTouchIsCancelledWhileWithinTheTarget
{
    [self.touchTracker touchWasCancelled];

}

@end


// TODO: CTDTrialSceneTouchTrackerTrackingFromATarget
