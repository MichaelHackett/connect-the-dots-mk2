// !!! Needs to be revised --- temporarily disabled !!!

// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDTrialSceneTouchRouter.h"

#import "Ports/CTDTouchMappers.h"

#import "CTDApplication/CTDTrialStepEditor.h"

#import "CTDFakeDotRenderer.h"
#import "CTDFakeTouchMapper.h"
#import "CTDFakeTouchResponder.h"
#import "CTDRecordingDotConnectionRenderer.h"
#import "CTDRecordingTouchTracker.h"
#import "CTDRecordingTrialRenderer.h"
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
#define POINT_INSIDE_DOT_1 point(45,99)
#define ANOTHER_POINT_INSIDE_DOT_1 point(47,95)
#define POINT_OUTSIDE_ELEMENTS point(22,70)
#define ANOTHER_POINT_OUTSIDE_ELEMENTS point(140,250)

#define SOME_DOT_COLOR CTDPaletteColor_DotType1




@interface CTDFakeTrialStep : NSObject <CTDTrialStepEditor, CTDTrialStepConnectionEditor>

@property (assign, readonly, nonatomic) BOOL connectionActive;

@end




@interface CTDTrialSceneTouchTrackerTestCase : XCTestCase

// The tracker instantiated by the router (created in subclass test cases)
@property (strong, nonatomic) id<CTDTouchTracker> subject;

// Collaborators
@property (strong, readonly, nonatomic) CTDTrialSceneTouchRouter* router;
@property (strong, readonly, nonatomic) CTDFakeTrialStep* trialStep;
@property (strong, readonly, nonatomic) id<CTDTouchToElementMapper> dotTouchMapper;
//@property (strong, readonly, nonatomic) CTDFakeTouchResponder* colorCellsTouchResponder;
//@property (strong, readonly, nonatomic) CTDRecordingTouchTracker* colorCellsTouchTracker;

// Test fixture
@property (strong, nonatomic) CTDFakeDotRenderer* dot1;

@end

@implementation CTDTrialSceneTouchTrackerTestCase

- (void)setUp
{
    [super setUp];

    self.dot1 = [[CTDFakeDotRenderer alloc]
                 initWithCenterPosition:DOT_1_CENTER
                               dotColor:SOME_DOT_COLOR];

//    CTDRecordingTouchTracker* colorCellsTouchTracker =
//        [[CTDRecordingTouchTracker alloc] init];
//    _colorCellsTouchTracker = colorCellsTouchTracker;
//    _colorCellsTouchResponder = [[CTDFakeTouchResponder alloc]
//                                 initWithTouchTrackerFactoryBlock:
//        ^(__unused CTDPoint* initialPosition)
//        {
//            return colorCellsTouchTracker;
//        }];

    _dotTouchMapper =
        [[CTDFakeTouchMapper alloc]
         initWithPointMap:@{ POINT_INSIDE_DOT_1: self.dot1,
                             ANOTHER_POINT_INSIDE_DOT_1: self.dot1 }];

    _trialStep = [[CTDFakeTrialStep alloc] init];

    _router = [[CTDTrialSceneTouchRouter alloc] init];
    _router.trialStepEditor = self.trialStep;
    _router.dotsTouchMapper = self.dotTouchMapper;
}

//- (CTDRecordingDotConnectionRenderer*)activeConnection {
//    return [self.trialRenderer.connectionRenderersCreated firstObject];
//}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchStartsOutsideAnyElement
    : CTDTrialSceneTouchTrackerTestCase
@end

@implementation CTDTrialSceneTouchTrackerWhenTouchStartsOutsideAnyElement

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatNoConnectionIsStarted
{
    assertThatBool(self.trialStep.connectionActive, is(equalToBool(NO)));
}

//- (void)testThatColorCellResponderIsAskedForATracker {
//    assertThat(self.colorCellsTouchResponder.touchStartingPositions, isNot(isEmpty()));
//}
//
//- (void)testThatColorCellResponderIsPassedTheInitialTouchPosition {
//    assertThat(self.colorCellsTouchResponder.touchStartingPositions[0],
//               is(equalTo(POINT_OUTSIDE_ELEMENTS)));
//}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutEnteringAnyElement
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutEnteringAnyElement

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidMoveTo:ANOTHER_POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatNoConnectionIsStarted
{
    assertThatBool(self.trialStep.connectionActive, is(equalToBool(NO)));
}

//- (void)testThatColorCellTrackerReceivedNewPosition
//{
//    assertThatBool([self.colorCellsTouchTracker hasReceivedMessageWithSelector:@selector(touchDidMoveTo:)],
//                   is(equalToBool(YES)));
//}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchFirstMovesOntoADot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchFirstMovesOntoADot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidMoveTo:POINT_INSIDE_DOT_1];
}

- (void)testThatAConnectionIsStarted
{
    assertThatBool(self.trialStep.connectionActive, is(equalToBool(YES)));
}

//- (void)testThatColorCellTrackerWasCancelled
//{
//    assertThat([[self.colorCellsTouchTracker touchTrackingMesssagesReceived] lastObject],
//               is(equalTo(message(touchWasCancelled))));
//}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchEndsWithoutEnteringAnyElement
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchEndsWithoutEnteringAnyElement

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidEnd];
}

- (void)testThatNoConnectionIsStarted
{
    assertThatBool(self.trialStep.connectionActive, is(equalToBool(NO)));
}

//- (void)testThatColorCellTrackerIsNotifedThatTouchEnded
//{
//    assertThat([[self.colorCellsTouchTracker touchTrackingMesssagesReceived] lastObject],
//               is(equalTo(message(touchDidEnd))));
//}

// TODO: separate tests for receiving `touchDidEnd` and that nothing came after?

@end




@interface CTDTrialSceneTouchTrackerWhenTouchIsCancelledBeforeEnteringAnyElement
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchIsCancelledBeforeEnteringAnyElement

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchWasCancelled];
}

- (void)testThatNoConnectionIsStarted
{
    assertThatBool(self.trialStep.connectionActive, is(equalToBool(NO)));
}

//- (void)testThatColorCellTrackerWasCancelled
//{
//    assertThat([[self.colorCellsTouchTracker touchTrackingMesssagesReceived] lastObject],
//               is(equalTo(message(touchWasCancelled))));
//}

@end



@interface CTDTrialSceneTouchTrackerWhenTouchStartsInsideADot
    : CTDTrialSceneTouchTrackerTestCase
@end

@implementation CTDTrialSceneTouchTrackerWhenTouchStartsInsideADot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_DOT_1];
}

- (void)testThatAConnectionIsStarted
{
    assertThatBool(self.trialStep.connectionActive, is(equalToBool(YES)));
}

//- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPosition {
//    assertThat([self activeConnection].secondEndpointPosition,
//               is(equalTo(POINT_INSIDE_DOT_1)));
//}
//
//- (void)testThatColorCellTrackerWasCancelled {
//    assertThat([[self.colorCellsTouchTracker touchTrackingMesssagesReceived] lastObject],
//               is(equalTo(message(touchWasCancelled))));
//}

@end



@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialDot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialDot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_DOT_1];
//    [self.colorCellsTouchTracker reset];
    [self.subject touchDidMoveTo:ANOTHER_POINT_INSIDE_DOT_1];
}

- (void)testThatTheConnectionRemainsActive
{
    assertThatBool(self.trialStep.connectionActive, is(equalToBool(YES)));
}

//- (void)testThatTheInitialDotRemainsSelected {
//    assertThatBool([dot1 isSelected], is(equalToBool(YES)));
//}
//
//- (void)testThatNoOtherDotBecomesSelected {
//    assertThat([self selectedDots], hasCountOf(1));
//}
//
//- (void)testThatTheFirstEndpointOfTheConnectionRemainsAnchoredToTheInitialDotConnectionPoint {
//    assertThat([self activeConnection].firstEndpointPosition,
//               is(equalTo([dot1 connectionPoint])));
//}
//
//- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPosition {
//    assertThat([self activeConnection].secondEndpointPosition,
//               is(equalTo(ANOTHER_POINT_INSIDE_DOT_1)));
//}

//- (void)testThatNoNewConnectionsAreStarted
//{
//    assertThat(self.trialRenderer.connectionRenderersCreated, hasCountOf(1));
//}
//
//- (void)testThatColorCellTrackerReceivedNoUpdates
//{
//    assertThat([self.colorCellsTouchTracker touchTrackingMesssagesReceived], isEmpty());
//}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialDot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialDot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_DOT_1];
//    [self.colorCellsTouchTracker reset];
    [self.subject touchDidMoveTo:POINT_OUTSIDE_ELEMENTS];
}

//- (void)testThatTheInitialDotRemainsSelected {
//    assertThatBool([dot1 isSelected], is(equalToBool(YES)));
//}
//
//- (void)testThatNoOtherDotsAreSelected {
//    assertThat([self selectedDots], hasCountOf(1));
//}
//
//- (void)testThatTheFirstEndpointOfTheConnectionRemainsAnchoredToTheInitialDotConnectionPoint {
//    assertThat([self activeConnection].firstEndpointPosition,
//               is(equalTo([dot1 connectionPoint])));
//}
//
//- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPosition {
//    assertThat([self activeConnection].secondEndpointPosition,
//               is(equalTo(POINT_OUTSIDE_ELEMENTS)));
//}

//- (void)testThatNoNewConnectionsAreStarted {
//    assertThat(self.trialRenderer.connectionRenderersCreated, hasCountOf(1));
//}

- (void)testThatTheConnectionRemainsActive
{
    assertThatBool(self.trialStep.connectionActive, is(equalToBool(YES)));
}

//- (void)testThatColorCellTrackerReceivedNoUpdates {
//    assertThat([self.colorCellsTouchTracker touchTrackingMesssagesReceived], isEmpty());
//}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinADot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinADot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_DOT_1];
//    [self.colorCellsTouchTracker reset];
    [self.subject touchDidEnd];
}

//- (void)testThatNoDotsAreSelected {
//    assertThat([self selectedDots], isEmpty());
//}

- (void)DISABLED_testThatTheConnectionIsEnded
{
    assertThatBool(self.trialStep.connectionActive, is(equalToBool(NO)));
}

//- (void)testThatTheConnectionIsDiscarded {
//    // TODO
//}

//- (void)testThatColorCellTrackerReceivedNoUpdates {
//    assertThat([self.colorCellsTouchTracker touchTrackingMesssagesReceived], isEmpty());
//}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinADot
    : CTDTrialSceneTouchTrackerTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinADot

- (void)setUp
{
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_DOT_1];
//    [self.colorCellsTouchTracker reset];
    [self.subject touchWasCancelled];
}

//- (void)testThatNoDotsAreSelected {
//    assertThat([self selectedDots], isEmpty());
//}

- (void)DISABLED_testThatTheConnectionIsEnded
{
    assertThatBool(self.trialStep.connectionActive, is(equalToBool(NO)));
}

//- (void)testThatTheConnectionIsDiscarded {
//    // TODO
//}

//- (void)testThatColorCellTrackerReceivedNoUpdates {
//    assertThat([self.colorCellsTouchTracker touchTrackingMesssagesReceived], isEmpty());
//}

@end

// TODO: CTDTrialSceneTouchTrackerTrackingFromADot




@implementation CTDFakeTrialStep

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _connectionActive = NO;
    }
    return self;
}

//- (void)beginConnection
//{
//    _connectionActive = YES;
//}
//
- (id<CTDTrialStepConnectionEditor>)editorForNewConnection
{
    _connectionActive = YES;
    return self;
}

- (void)cancelConnection
{
    _connectionActive = NO;
}

@end
