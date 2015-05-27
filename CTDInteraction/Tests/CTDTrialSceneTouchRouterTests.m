// !!! Needs to be revised --- temporarily disabled !!!

// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDTrialSceneTouchRouter.h"

#import "CTDPresentation/CTDDotConnectionRenderer.h"
#import "CTDPresentation/CTDDotRenderer.h"
#import "CTDFakeDotRenderer.h"
#import "CTDFakeTouchMapper.h"
#import "CTDFakeTouchResponder.h"
#import "CTDRecordingDotConnectionView.h"
#import "CTDRecordingTouchTracker.h"
#import "CTDRecordingTrialRenderer.h"
#import "CTDTouchMapper.h"
#import "CTDTrialRenderer.h"
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



static CTDFakeDotRenderer* dot1;




@interface CTDTrialSceneTouchTrackerBaseTestCase : XCTestCase

// The tracker instantiated by the router (created in subclass test cases)
@property (strong, nonatomic) id<CTDTouchTracker> subject;

@property (strong, readonly, nonatomic) CTDTrialSceneTouchRouter* router;
@property (strong, readonly, nonatomic) CTDRecordingTrialRenderer* trialRenderer;
@property (strong, readonly, nonatomic) CTDFakeTouchResponder* colorCellsTouchResponder;
@property (strong, readonly, nonatomic) CTDRecordingTouchTracker* colorCellsTouchTracker;
@end

@implementation CTDTrialSceneTouchTrackerBaseTestCase

- (void)setUp
{
    [super setUp];

    dot1 = [[CTDFakeDotRenderer alloc]
            initWithCenterPosition:DOT_1_CENTER
                          dotColor:SOME_DOT_COLOR];

    _trialRenderer = [[CTDRecordingTrialRenderer alloc] init];
    CTDRecordingTouchTracker* colorCellsTouchTracker =
            [[CTDRecordingTouchTracker alloc] init];
    _colorCellsTouchTracker = colorCellsTouchTracker;
    _colorCellsTouchResponder = [[CTDFakeTouchResponder alloc]
                                 initWithTouchTrackerFactoryBlock:
        ^(__unused CTDPoint* initialPosition)
        {
            return colorCellsTouchTracker;
        }];

    id<CTDTouchMapper> dotTouchMapper =
        [[CTDFakeTouchMapper alloc]
         initWithPointMap:@{ POINT_INSIDE_DOT_1: dot1,
                             ANOTHER_POINT_INSIDE_DOT_1: dot1 }];

    _router = [[CTDTrialSceneTouchRouter alloc]
               initWithTrialRenderer:_trialRenderer
               dotsTouchMapper:dotTouchMapper
               colorCellsTouchResponder:_colorCellsTouchResponder];
}

- (void)tearDown
{
    dot1 = nil;
    [super tearDown];
}

- (NSArray*)selectedDots
{
    NSMutableArray* selectedDots = [[NSMutableArray alloc] init];
    if ([dot1 isSelected]) { [selectedDots addObject:dot1]; }
    return selectedDots;
}

- (CTDRecordingDotConnectionView*)activeConnection {
    return [self.trialRenderer.connectionViewsCreated firstObject];
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchStartsOutsideAnyElement
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchStartsOutsideAnyElement

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatNoDotsAreSelected {
    assertThat([self selectedDots], isEmpty());
}

- (void)testThatNoConnectionsAreStarted {
    assertThat(self.trialRenderer.connectionViewsCreated, isEmpty());
}

- (void)testThatColorCellResponderIsAskedForATracker {
    assertThat(self.colorCellsTouchResponder.touchStartingPositions, isNot(isEmpty()));
}

- (void)testThatColorCellResponderIsPassedTheInitialTouchPosition {
    assertThat(self.colorCellsTouchResponder.touchStartingPositions[0],
               is(equalTo(POINT_OUTSIDE_ELEMENTS)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutEnteringAnyElement
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutEnteringAnyElement

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidMoveTo:ANOTHER_POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatNoDotsAreSelected {
    assertThat([self selectedDots], isEmpty());
}

- (void)testThatNoConnectionsAreStarted {
    assertThat(self.trialRenderer.connectionViewsCreated, isEmpty());
}

- (void)testThatColorCellTrackerReceivedNewPosition {
    assertThatBool([self.colorCellsTouchTracker hasReceivedMessageWithSelector:@selector(touchDidMoveTo:)],
                   is(equalToBool(YES)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchFirstMovesOntoADot
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchFirstMovesOntoADot

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidMoveTo:POINT_INSIDE_DOT_1];
}

- (void)testThatTheDotIsSelected {
    assertThatBool([dot1 isSelected], is(equalToBool(YES)));
}

- (void)testThatNoOtherDotsAreSelected {
    assertThat([self selectedDots], hasCountOf(1));
}

- (void)testThatAConnectionIsStarted {
    assertThat(self.trialRenderer.connectionViewsCreated, hasCountOf(1));
}

- (void)testThatColorCellTrackerWasCancelled {
    assertThat([[self.colorCellsTouchTracker touchTrackingMesssagesReceived] lastObject],
               is(equalTo(message(touchWasCancelled))));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchEndsOutsideOfAnyElement
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchEndsOutsideOfAnyElement

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidEnd];
}

- (void)testThatNoDotsAreSelected {
    assertThat([self selectedDots], isEmpty());
}

- (void)testThatColorCellTrackerIsNotifedThatTouchEnded {
    assertThat([[self.colorCellsTouchTracker touchTrackingMesssagesReceived] lastObject],
               is(equalTo(message(touchDidEnd))));
}

// TODO: separate tests for receiving `touchDidEnd` and that nothing came after?

@end




@interface CTDTrialSceneTouchTrackerWhenTouchIsCancelledOutsideOfAnyElement
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchIsCancelledOutsideOfAnyElement

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchWasCancelled];
}

- (void)testThatNoDotsAreSelected {
    assertThat([self selectedDots], isEmpty());
}

- (void)testThatColorCellTrackerWasCancelled {
    assertThat([[self.colorCellsTouchTracker touchTrackingMesssagesReceived] lastObject],
               is(equalTo(message(touchWasCancelled))));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchStartsInsideADot
    : CTDTrialSceneTouchTrackerBaseTestCase
@end

@implementation CTDTrialSceneTouchTrackerWhenTouchStartsInsideADot

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_DOT_1];
}

- (void)testThatTheDotIsSelected {
    assertThatBool([dot1 isSelected], is(equalToBool(YES)));
}

- (void)testThatNoOtherDotsAreSelected {
    assertThat([self selectedDots], hasCountOf(1));
}

- (void)testThatAConnectionIsStarted {
    assertThat(self.trialRenderer.connectionViewsCreated, hasCountOf(1));
}

- (void)testThatTheFirstEndpointOfTheConnectionIsAnchoredToTheDotConnectionPoint {
    assertThat([self activeConnection].firstEndpointPosition,
               is(equalTo([dot1 connectionPoint])));
}

- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPosition {
    assertThat([self activeConnection].secondEndpointPosition,
               is(equalTo(POINT_INSIDE_DOT_1)));
}

- (void)testThatColorCellTrackerWasCancelled {
    assertThat([[self.colorCellsTouchTracker touchTrackingMesssagesReceived] lastObject],
               is(equalTo(message(touchWasCancelled))));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialDot
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialDot

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_DOT_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchDidMoveTo:ANOTHER_POINT_INSIDE_DOT_1];
}

- (void)testThatTheInitialDotRemainsSelected {
    assertThatBool([dot1 isSelected], is(equalToBool(YES)));
}

- (void)testThatNoOtherDotBecomesSelected {
    assertThat([self selectedDots], hasCountOf(1));
}

- (void)testThatTheFirstEndpointOfTheConnectionRemainsAnchoredToTheInitialDotConnectionPoint {
    assertThat([self activeConnection].firstEndpointPosition,
               is(equalTo([dot1 connectionPoint])));
}

- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPosition {
    assertThat([self activeConnection].secondEndpointPosition,
               is(equalTo(ANOTHER_POINT_INSIDE_DOT_1)));
}

- (void)testThatNoNewConnectionsAreStarted {
    assertThat(self.trialRenderer.connectionViewsCreated, hasCountOf(1));
}

- (void)testThatColorCellTrackerReceivedNoUpdates {
    assertThat([self.colorCellsTouchTracker touchTrackingMesssagesReceived], isEmpty());
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialDot
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialDot

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_DOT_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchDidMoveTo:POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatTheInitialDotRemainsSelected {
    assertThatBool([dot1 isSelected], is(equalToBool(YES)));
}

- (void)testThatNoOtherDotsAreSelected {
    assertThat([self selectedDots], hasCountOf(1));
}

- (void)testThatTheFirstEndpointOfTheConnectionRemainsAnchoredToTheInitialDotConnectionPoint {
    assertThat([self activeConnection].firstEndpointPosition,
               is(equalTo([dot1 connectionPoint])));
}

- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPosition {
    assertThat([self activeConnection].secondEndpointPosition,
               is(equalTo(POINT_OUTSIDE_ELEMENTS)));
}

- (void)testThatNoNewConnectionsAreStarted {
    assertThat(self.trialRenderer.connectionViewsCreated, hasCountOf(1));
}

- (void)testThatColorCellTrackerReceivedNoUpdates {
    assertThat([self.colorCellsTouchTracker touchTrackingMesssagesReceived], isEmpty());
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinADot
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinADot
- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_DOT_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchDidEnd];
}

- (void)testThatNoDotsAreSelected {
    assertThat([self selectedDots], isEmpty());
}

//- (void)testThatTheConnectionIsDiscarded {
//    // TODO
//}

- (void)testThatColorCellTrackerReceivedNoUpdates {
    assertThat([self.colorCellsTouchTracker touchTrackingMesssagesReceived], isEmpty());
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinADot
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinADot

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_DOT_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchWasCancelled];
}

- (void)testThatNoDotsAreSelected {
    assertThat([self selectedDots], isEmpty());
}

//- (void)testThatTheConnectionIsDiscarded {
//    // TODO
//}

- (void)testThatColorCellTrackerReceivedNoUpdates {
    assertThat([self.colorCellsTouchTracker touchTrackingMesssagesReceived], isEmpty());
}

@end




// TODO: CTDTrialSceneTouchTrackerTrackingFromADot

