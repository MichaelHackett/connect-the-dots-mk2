// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTrialSceneTouchRouter.h"

#import "CTDFakeTargetRenderer.h"
#import "CTDFakeTouchResponder.h"
#import "CTDRecordingTargetConnectionView.h"
#import "CTDRecordingTouchTracker.h"
#import "CTDRecordingTrialRenderer.h"
#import "CTDTargetConnectionView.h"
#import "CTDTargetRenderer.h"
#import "CTDTouchMapper.h"
#import "CTDTrialRenderer.h"
#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"

#define point CTDMakePoint



//
// Test data
//

// Note: These coordinate values are arbitrary, but CTDPoint comparisons are
// done by value, so the coordinates all must be unique.
#define TARGET_1_CENTER point(40,96)
#define POINT_INSIDE_TARGET_1 point(45,99)
#define ANOTHER_POINT_INSIDE_TARGET_1 point(47,95)
#define POINT_OUTSIDE_ELEMENTS point(22,70)
#define ANOTHER_POINT_OUTSIDE_ELEMENTS point(140,250)



static CTDFakeTargetRenderer* target1;




@interface CTDFakeTargetTouchMapper : NSObject <CTDTouchMapper>
@end
@implementation CTDFakeTargetTouchMapper

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

    target1 = [[CTDFakeTargetRenderer alloc] initWithCenterPosition:TARGET_1_CENTER];

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

    _router = [[CTDTrialSceneTouchRouter alloc]
               initWithTrialRenderer:_trialRenderer
               targetsTouchMapper:[[CTDFakeTargetTouchMapper alloc] init]
               colorCellsTouchResponder:_colorCellsTouchResponder];
}

- (void)tearDown
{
    target1 = nil;
    [super tearDown];
}

- (NSArray*)selectedTargets
{
    NSMutableArray* selectedTargets = [[NSMutableArray alloc] init];
    if ([target1 isSelected]) { [selectedTargets addObject:target1]; }
    return selectedTargets;
}

- (CTDRecordingTargetConnectionView*)activeConnection {
    return [self.trialRenderer.targetConnectionViewsCreated firstObject];
}

- (BOOL)colorCellTrackerWasEnded {
    return [[self.colorCellsTouchTracker.messagesReceived lastObject]
            isEqual:[[CTDMethodSelector alloc]
                     initWithRawSelector:@selector(touchDidEnd)]];
}

- (BOOL)colorCellTrackerWasCancelled {
    return [[self.colorCellsTouchTracker.messagesReceived lastObject]
            isEqual:[[CTDMethodSelector alloc]
                     initWithRawSelector:@selector(touchWasCancelled)]];
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

- (void)testThatNoTargetsAreSelected {
    assertThat([self selectedTargets], isEmpty());
}

- (void)testThatNoConnectionsAreStarted {
    assertThat(self.trialRenderer.targetConnectionViewsCreated, isEmpty());
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

- (void)testThatNoTargetsAreSelected {
    assertThat([self selectedTargets], isEmpty());
}

- (void)testThatNoConnectionsAreStarted {
    assertThat(self.trialRenderer.targetConnectionViewsCreated, isEmpty());
}

- (void)testThatColorCellTrackerReceivedNewPosition {
    assertThat(self.colorCellsTouchTracker.messagesReceived,
               hasItem([[CTDMethodSelector alloc]
                        initWithRawSelector:@selector(touchDidMoveTo:)]));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchFirstMovesOntoATarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchFirstMovesOntoATarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidMoveTo:POINT_INSIDE_TARGET_1];
}

- (void)testThatTheTargetIsSelected {
    assertThatBool([target1 isSelected], is(equalToBool(YES)));
}

- (void)testThatNoOtherTargetsAreSelected {
    assertThat([self selectedTargets], hasCountOf(1));
}

- (void)testThatAConnectionIsStarted {
    assertThat(self.trialRenderer.targetConnectionViewsCreated, hasCountOf(1));
}

- (void)testThatColorCellTrackerWasCancelled {
    assertThatBool([self colorCellTrackerWasCancelled], is(equalToBool(YES)));
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

- (void)testThatNoTargetsAreSelected {
    assertThat([self selectedTargets], isEmpty());
}

- (void)testThatColorCellTrackerIsNotifedThatTouchEnded {
    assertThatBool([self colorCellTrackerWasEnded], is(equalToBool(YES)));
}

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

- (void)testThatNoTargetsAreSelected {
    assertThat([self selectedTargets], isEmpty());
}

- (void)testThatColorCellTrackerWasCancelled {
    assertThatBool([self colorCellTrackerWasCancelled], is(equalToBool(YES)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchStartsInsideATarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end

@implementation CTDTrialSceneTouchTrackerWhenTouchStartsInsideATarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
}

- (void)testThatTheTargetIsSelected {
    assertThatBool([target1 isSelected], is(equalToBool(YES)));
}

- (void)testThatNoOtherTargetsAreSelected {
    assertThat([self selectedTargets], hasCountOf(1));
}

- (void)testThatAConnectionIsStarted {
    assertThat(self.trialRenderer.targetConnectionViewsCreated, hasCountOf(1));
}

- (void)testThatTheFirstEndpointOfTheConnectionIsAnchoredToTheTargetConnectionPoint {
    assertThat([self activeConnection].firstEndpointPosition,
               is(equalTo([target1 connectionPoint])));
}

- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPosition {
    assertThat([self activeConnection].secondEndpointPosition,
               is(equalTo(POINT_INSIDE_TARGET_1)));
}

- (void)testThatColorCellTrackerWasCancelled {
    assertThatBool([self colorCellTrackerWasCancelled], is(equalToBool(YES)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialTarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialTarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchDidMoveTo:ANOTHER_POINT_INSIDE_TARGET_1];
}

- (void)testThatTheInitialTargetRemainsSelected {
    assertThatBool([target1 isSelected], is(equalToBool(YES)));
}

- (void)testThatNoOtherTargetBecomesSelected {
    assertThat([self selectedTargets], hasCountOf(1));
}

- (void)testThatTheFirstEndpointOfTheConnectionRemainsAnchoredToTheInitialTargetConnectionPoint {
    assertThat([self activeConnection].firstEndpointPosition,
               is(equalTo([target1 connectionPoint])));
}

- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPosition {
    assertThat([self activeConnection].secondEndpointPosition,
               is(equalTo(ANOTHER_POINT_INSIDE_TARGET_1)));
}

- (void)testThatNoNewConnectionsAreStarted {
    assertThat(self.trialRenderer.targetConnectionViewsCreated, hasCountOf(1));
}

- (void)testThatColorCellTrackerReceivedNoUpdates {
    assertThat(self.colorCellsTouchTracker.messagesReceived, isEmpty());
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialTarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialTarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchDidMoveTo:POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatTheInitialTargetRemainsSelected {
    assertThatBool([target1 isSelected], is(equalToBool(YES)));
}

- (void)testThatNoOtherTargetsAreSelected {
    assertThat([self selectedTargets], hasCountOf(1));
}

- (void)testThatTheFirstEndpointOfTheConnectionRemainsAnchoredToTheInitialTargetConnectionPoint {
    assertThat([self activeConnection].firstEndpointPosition,
               is(equalTo([target1 connectionPoint])));
}

- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPosition {
    assertThat([self activeConnection].secondEndpointPosition,
               is(equalTo(POINT_OUTSIDE_ELEMENTS)));
}

- (void)testThatNoNewConnectionsAreStarted {
    assertThat(self.trialRenderer.targetConnectionViewsCreated, hasCountOf(1));
}

- (void)testThatColorCellTrackerReceivedNoUpdates {
    assertThat(self.colorCellsTouchTracker.messagesReceived, isEmpty());
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinATarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinATarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchDidEnd];
}

- (void)testThatNoTargetsAreSelected {
    assertThat([self selectedTargets], isEmpty());
}

//- (void)testThatTheConnectionIsDiscarded {
//    // TODO
//}

- (void)testThatColorCellTrackerReceivedNoUpdates {
    assertThat(self.colorCellsTouchTracker.messagesReceived, isEmpty());
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinATarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinATarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
    [self.colorCellsTouchTracker reset];
    [self.subject touchWasCancelled];
}

- (void)testThatNoTargetsAreSelected {
    assertThat([self selectedTargets], isEmpty());
}

//- (void)testThatTheConnectionIsDiscarded {
//    // TODO
//}

- (void)testThatColorCellTrackerReceivedNoUpdates {
    assertThat(self.colorCellsTouchTracker.messagesReceived, isEmpty());
}

@end




// TODO: CTDTrialSceneTouchTrackerTrackingFromATarget

