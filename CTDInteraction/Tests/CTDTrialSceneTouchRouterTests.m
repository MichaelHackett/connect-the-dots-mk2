// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDTrialSceneTouchRouter.h"

#import "Ports/CTDTouchMappers.h"
#import "CTDApplication/CTDTrialEditor.h"

#import "CTDFakeTouchMappers.h"
#import "CTDFakeTouchResponder.h"
#import "CTDFakeTouchTracker.h"
#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"

#define message CTDMakeMethodSelector
#define point CTDMakePoint



//
// Test data
//

// Note: These coordinate values are arbitrary, but CTDPoint comparisons are
// done by value, so the coordinates all must be unique.
#define DOT_1_CENTER point(40,96)
#define TOUCH_POINT_INSIDE_DOT_1 point(45,99)
#define ANOTHER_TOUCH_POINT_INSIDE_DOT_1 point(47,95)
#define TOUCH_POINT_INSIDE_DOT_2 point(430,165)
#define TOUCH_POINT_OUTSIDE_ELEMENTS point(22,70)
#define ANOTHER_TOUCH_POINT_OUTSIDE_ELEMENTS point(140,250)
#define TOUCH_POINT_OUTSIDE_WINDOW point(999,999)

#define SOME_TRIAL_POINT point(100,150)
#define SOME_OTHER_TRIAL_POINT point(275,40)
#define TRIAL_POINT_OUTSIDE_ELEMENTS point(15,15)

#define SOME_DOT_COLOR CTDPaletteColor_DotType1

#define STARTING_DOT_ID @1
#define ENDING_DOT_ID @2


// The states a trial-step connection can be in.
typedef enum
{
    kCTDTrialConnectionStateInactive,
    kCTDTrialConnectionStateActive,
    kCTDTrialConnectionStateEstablished,
    kCTDTrialConnectionStateCompleted
}
CTDTrialConnectionState;




@interface CTDFakeTrialEditor : NSObject <CTDTrialEditor>

@property (strong, nonatomic) id<CTDTrialStepEditor> editorForCurrentStep;

@end



@interface CTDFakeTrialStep : NSObject <CTDTrialStepEditor, CTDTrialStepConnectionEditor>

@property (assign, readonly, nonatomic) CTDTrialConnectionState connectionState;
@property (copy, readonly, nonatomic) CTDPoint* connectionFreeEndPosition;

@end





@interface CTDTrialSceneTouchTrackerTestCase : XCTestCase

// The tracker instantiated by the router (created in subclass test cases)
@property (strong, nonatomic) id<CTDTouchTracker> subject;

// Collaborators
@property (strong, readonly, nonatomic) CTDTrialSceneTouchRouter* router;
@property (strong, readonly, nonatomic) CTDFakeTrialEditor* trialEditor;
@property (strong, readonly, nonatomic) CTDFakeTrialStep* trialStep;
@property (strong, readonly, nonatomic) id<CTDTouchToElementMapper> dotTouchMapper;
@property (strong, readonly, nonatomic) id<CTDTouchToPointMapper> freeEndMapper;
@property (strong, readonly, nonatomic) CTDFakeTouchResponder* colorCellsTouchResponder;
@property (strong, readonly, nonatomic) CTDFakeTouchTracker* colorCellsTouchTracker;

// Test fixture

@end


// Convenience assertion
#define assertThatConnectionStateIs(EXPECTED_STATE) assertThatUnsignedInteger(self.trialStep.connectionState, is(equalToUnsignedInteger(kCTDTrialConnectionState ## EXPECTED_STATE)))



@implementation CTDTrialSceneTouchTrackerTestCase

- (void)setUp
{
    [super setUp];

    CTDFakeTouchTracker* colorCellsTouchTracker = [[CTDFakeTouchTracker alloc] init];
    _colorCellsTouchTracker = colorCellsTouchTracker;
    _colorCellsTouchResponder = [[CTDFakeTouchResponder alloc]
                                 initWithTouchTrackerFactoryBlock:
        ^(__unused CTDPoint* initialPosition)
        {
            return colorCellsTouchTracker;
        }];

    _dotTouchMapper =
        [[CTDFakeTouchToElementMapper alloc]
         initWithPointMap:@{ TOUCH_POINT_INSIDE_DOT_1: @1,
                             ANOTHER_TOUCH_POINT_INSIDE_DOT_1: @1,
                             TOUCH_POINT_INSIDE_DOT_2: @2 }];

    _freeEndMapper =
        [[CTDFakeTouchToPointMapper alloc]
         initWithPointMap:@{ TOUCH_POINT_INSIDE_DOT_1: SOME_TRIAL_POINT,
                             ANOTHER_TOUCH_POINT_INSIDE_DOT_1: SOME_OTHER_TRIAL_POINT,
                             TOUCH_POINT_OUTSIDE_ELEMENTS: TRIAL_POINT_OUTSIDE_ELEMENTS }];

    _trialStep = [[CTDFakeTrialStep alloc] init];
    _trialEditor = [[CTDFakeTrialEditor alloc] init];
    self.trialEditor.editorForCurrentStep = _trialStep;

    _router = [[CTDTrialSceneTouchRouter alloc] init];
    _router.trialEditor = self.trialEditor;
    _router.dotsTouchMapper = self.dotTouchMapper;
    _router.freeEndMapper = self.freeEndMapper;
    _router.colorCellsTouchResponder = self.colorCellsTouchResponder;
}

@end




@interface CTDTrialSceneTouchRouterPriorToAnyTouch
    : CTDTrialSceneTouchTrackerTestCase
@end

@implementation CTDTrialSceneTouchRouterPriorToAnyTouch

- (void)testThatNoConnectionIsStarted
{
    assertThatConnectionStateIs(Inactive);
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchStartsOutsideAnyElement
    : CTDTrialSceneTouchTrackerTestCase
@end

@implementation CTDTrialSceneTouchTrackerWhenTouchStartsOutsideAnyElement

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatNoConnectionIsStarted
{
    assertThatConnectionStateIs(Inactive);
}

- (void)testThatColorCellTouchResponderIsAskedForATracker
{
    assertThat(self.colorCellsTouchResponder.touchStartingPositions, isNot(isEmpty()));
}

- (void)testThatColorCellResponderIsPassedTheInitialTouchPosition
{
    assertThat(self.colorCellsTouchResponder.touchStartingPositions[0],
               is(equalTo(TOUCH_POINT_OUTSIDE_ELEMENTS)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutEnteringAnyElement
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutEnteringAnyElement

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidMoveTo:ANOTHER_TOUCH_POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatNoConnectionIsStarted
{
    assertThatConnectionStateIs(Inactive);
}

- (void)testThatColorCellTrackerReceivedNewPosition
{
    assertThat(self.colorCellsTouchTracker.lastTouchPosition,
               is(equalTo(ANOTHER_TOUCH_POINT_OUTSIDE_ELEMENTS)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchFirstMovesOntoStartingDot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchFirstMovesOntoStartingDot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidMoveTo:TOUCH_POINT_INSIDE_DOT_1];
}

- (void)testThatAConnectionIsActive
{
    assertThatConnectionStateIs(Active);
}

- (void)testThatTheFreeEndOfTheConnectionFollowsTheTouchPosition
{
    assertThat(self.trialStep.connectionFreeEndPosition, is(equalTo(SOME_TRIAL_POINT)));
}

- (void)testThatColorCellTrackerWasCancelled
{
    assertThat(self.colorCellsTouchTracker.state, is(equalTo(CTDTouchTrackerStateCancelled)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchEndsWithoutEnteringAnyElement
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchEndsWithoutEnteringAnyElement

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidEnd];
}

- (void)testThatNoConnectionIsStarted
{
    assertThatConnectionStateIs(Inactive);
}

- (void)testThatColorCellTrackerIsNotifedThatTouchEnded
{
    assertThat(self.colorCellsTouchTracker.state, is(equalTo(CTDTouchTrackerStateEnded)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchIsCancelledBeforeEnteringAnyElement
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchIsCancelledBeforeEnteringAnyElement

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_OUTSIDE_ELEMENTS];
    [self.subject touchWasCancelled];
}

- (void)testThatNoConnectionIsStarted
{
    assertThatConnectionStateIs(Inactive);
}

- (void)testThatColorCellTrackerWasCancelled
{
    assertThat(self.colorCellsTouchTracker.state, is(equalTo(CTDTouchTrackerStateCancelled)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchStartsInsideStartingDot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchStartsInsideStartingDot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_INSIDE_DOT_1];
}

- (void)testThatConnectionIsActive
{
    assertThatConnectionStateIs(Active);
}

- (void)testThatTheFreeEndOfTheConnectionFollowsTheTouchPosition
{
    assertThat(self.trialStep.connectionFreeEndPosition, is(equalTo(SOME_TRIAL_POINT)));
}

- (void)testThatColorCellTrackerWasCancelled
{
    assertThat(self.colorCellsTouchTracker.state, is(equalTo(CTDTouchTrackerStateCancelled)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchStartsInsideEndingDot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchStartsInsideEndingDot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_INSIDE_DOT_2];
}

- (void)testThatNoConnectionIsStarted
{
    assertThatConnectionStateIs(Inactive);
}

- (void)testThatColorCellTouchResponderIsAskedForATracker
{
    assertThat(self.colorCellsTouchResponder.touchStartingPositions, isNot(isEmpty()));
}

- (void)testThatColorCellResponderIsPassedTheInitialTouchPosition
{
    assertThat(self.colorCellsTouchResponder.touchStartingPositions[0],
               is(equalTo(TOUCH_POINT_INSIDE_DOT_2)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialDot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialDot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_INSIDE_DOT_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchDidMoveTo:ANOTHER_TOUCH_POINT_INSIDE_DOT_1];
}

- (void)testThatTheConnectionRemainsActive
{
    assertThatConnectionStateIs(Active);
}

- (void)testThatTheFreeEndOfTheConnectionFollowsTheTouchPosition
{
    assertThat(self.trialStep.connectionFreeEndPosition, is(equalTo(SOME_OTHER_TRIAL_POINT)));
}

- (void)testThatColorCellTrackerReceivedNoUpdates
{
    assertThat(self.colorCellsTouchTracker.lastTouchPosition, is(nilValue()));
    assertThat(self.colorCellsTouchTracker.state, is(equalTo(CTDTouchTrackerStateActive)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialDot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialDot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_INSIDE_DOT_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchDidMoveTo:TOUCH_POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatTheFreeEndOfTheConnectionFollowsTheTouchPosition
{
    assertThat(self.trialStep.connectionFreeEndPosition, is(equalTo(TRIAL_POINT_OUTSIDE_ELEMENTS)));
}

- (void)testThatTheConnectionRemainsActive
{
    assertThatConnectionStateIs(Active);
}

- (void)testThatColorCellTrackerReceivedNoUpdates
{
    assertThat(self.colorCellsTouchTracker.lastTouchPosition, is(nilValue()));
    assertThat(self.colorCellsTouchTracker.state, is(equalTo(CTDTouchTrackerStateActive)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenConnectionDraggedOutsideOfWindow
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenConnectionDraggedOutsideOfWindow

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_INSIDE_DOT_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchDidMoveTo:TOUCH_POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidMoveTo:TOUCH_POINT_OUTSIDE_WINDOW];
}

- (void)testThatTheFreeEndOfTheConnectionSticksToLastPointInsideWindow
{
    assertThat(self.trialStep.connectionFreeEndPosition, is(equalTo(TRIAL_POINT_OUTSIDE_ELEMENTS)));
}

- (void)testThatTheConnectionRemainsActive
{
    assertThatConnectionStateIs(Active);
}

- (void)testThatColorCellTrackerReceivedNoUpdates
{
    assertThat(self.colorCellsTouchTracker.lastTouchPosition, is(nilValue()));
    assertThat(self.colorCellsTouchTracker.state, is(equalTo(CTDTouchTrackerStateActive)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenConnectionDraggedIntoSecondDot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenConnectionDraggedIntoSecondDot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_INSIDE_DOT_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchDidMoveTo:TOUCH_POINT_INSIDE_DOT_2];
}

- (void)testThatConnectionIsEstablished
{
    assertThatConnectionStateIs(Established);
}

- (void)testThatColorCellTrackerReceivedNoUpdates
{
    assertThat(self.colorCellsTouchTracker.lastTouchPosition, is(nilValue()));
    assertThat(self.colorCellsTouchTracker.state, is(equalTo(CTDTouchTrackerStateActive)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenConnectionDraggedBackOntoFirstDot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenConnectionDraggedBackOntoFirstDot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_INSIDE_DOT_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchDidMoveTo:TOUCH_POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidMoveTo:TOUCH_POINT_INSIDE_DOT_1];
}

- (void)testThatTheConnectionRemainsActive
{
    assertThatConnectionStateIs(Active);
}

- (void)testThatColorCellTrackerReceivedNoUpdates
{
    assertThat(self.colorCellsTouchTracker.lastTouchPosition, is(nilValue()));
    assertThat(self.colorCellsTouchTracker.state, is(equalTo(CTDTouchTrackerStateActive)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinStartingDot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinStartingDot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_INSIDE_DOT_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchDidEnd];
}

- (void)testThatTheConnectionIsEnded
{
    assertThatConnectionStateIs(Inactive);
}

//- (void)testThatTheConnectionIsDiscarded
//{
//    // TODO
//}

- (void)testThatColorCellTrackerReceivedNoUpdates
{
    assertThat(self.colorCellsTouchTracker.lastTouchPosition, is(nilValue()));
    assertThat(self.colorCellsTouchTracker.state, is(equalTo(CTDTouchTrackerStateActive)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinStartingDot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinStartingDot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_INSIDE_DOT_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchWasCancelled];
}

- (void)testThatTheConnectionIsEnded
{
    assertThatConnectionStateIs(Inactive);
}

//- (void)testThatTheConnectionIsDiscarded
//{
//    // TODO
//}

- (void)testThatColorCellTrackerReceivedNoUpdates
{
    assertThat(self.colorCellsTouchTracker.lastTouchPosition, is(nilValue()));
    assertThat(self.colorCellsTouchTracker.state, is(equalTo(CTDTouchTrackerStateActive)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchIsEndedWhileWithinEndingDot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchIsEndedWhileWithinEndingDot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:TOUCH_POINT_INSIDE_DOT_1];
    [self.subject touchDidMoveTo:TOUCH_POINT_INSIDE_DOT_2];
    [self.colorCellsTouchTracker reset];
    [self.subject touchDidEnd];
}

- (void)testThatTheConnectionIsSuccessfullyCompleted
{
    assertThatConnectionStateIs(Completed);
}

@end


// TODO: CTDTrialSceneTouchTrackerTrackingFromADot
// - touching first dot after connection is started should have no effect




@implementation CTDFakeTrialEditor

- (id)init
{
    self = [super init];
    if (self) {
        _editorForCurrentStep = nil;
    }
    return self;
}

- (void)beginTrial {}
- (void)advanceToNextStep {}
- (id<CTDSelectionEditor>)editorForColorSelection { return nil; }

@end




@implementation CTDFakeTrialStep

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _connectionState = kCTDTrialConnectionStateInactive;
        _connectionFreeEndPosition = nil;
    }
    return self;
}

- (id<CTDTrialStepConnectionEditor>)editorForNewConnection
{
    _connectionState = kCTDTrialConnectionStateActive;
    return self;
}

- (id)startingDotId
{
    return STARTING_DOT_ID;
}

- (id)endingDotId
{
    return ENDING_DOT_ID;
}

- (void)invalidate {}

- (void)setFreeEndPosition:(CTDPoint*)freeEndPosition
{
    NSAssert(_connectionState == kCTDTrialConnectionStateActive ||
             _connectionState == kCTDTrialConnectionStateEstablished,
             @"Connection is not in a valid state for changing its free end position.");

    _connectionFreeEndPosition = [freeEndPosition copy];
    _connectionState = kCTDTrialConnectionStateActive;
}

- (void)establishConnection
{
    _connectionState = kCTDTrialConnectionStateEstablished;
    _connectionFreeEndPosition = nil;
}

- (void)commitConnectionState
{
    if (_connectionState == kCTDTrialConnectionStateEstablished)
    {
        _connectionState = kCTDTrialConnectionStateCompleted;
    }
    else
    {
        _connectionState = kCTDTrialConnectionStateInactive;
    }
}

- (void)cancelConnection
{
    _connectionState = kCTDTrialConnectionStateInactive;
    _connectionFreeEndPosition = nil;
}

@end
