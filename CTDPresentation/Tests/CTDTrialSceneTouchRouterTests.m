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
#import <XCTest/XCTest.h>



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
@property (strong, readonly, nonatomic) CTDFakeTouchResponder* colorButtonsTouchResponder;
@property (strong, readonly, nonatomic) CTDRecordingTouchTracker* colorButtonsTouchTracker;
@end

@implementation CTDTrialSceneTouchTrackerBaseTestCase

- (void)setUp
{
    [super setUp];

    target1 = [[CTDFakeTargetRenderer alloc] initWithCenterPosition:TARGET_1_CENTER];

    _trialRenderer = [[CTDRecordingTrialRenderer alloc] init];
    CTDRecordingTouchTracker* colorButtonsTouchTracker =
            [[CTDRecordingTouchTracker alloc] init];
    _colorButtonsTouchTracker = colorButtonsTouchTracker;
    _colorButtonsTouchResponder = [[CTDFakeTouchResponder alloc]
                                   initWithTouchTrackerFactoryBlock:
        ^(__unused CTDPoint* initialPosition)
        {
            return colorButtonsTouchTracker;
        }];

    _router = [[CTDTrialSceneTouchRouter alloc]
               initWithTrialRenderer:_trialRenderer
               targetsTouchMapper:[[CTDFakeTargetTouchMapper alloc] init]
               colorButtonsTouchResponder:_colorButtonsTouchResponder];
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

- (BOOL)colorButtonTrackerWasEnded {
    return [[self.colorButtonsTouchTracker.messagesReceived lastObject]
            isEqual:[[CTDMethodSelector alloc]
                     initWithRawSelector:@selector(touchDidEnd)]];
}

- (BOOL)colorButtonTrackerWasCancelled {
    return [[self.colorButtonsTouchTracker.messagesReceived lastObject]
            isEqual:[[CTDMethodSelector alloc]
                     initWithRawSelector:@selector(touchWasCancelled)]];
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchStartsOutsideAnyElement : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchStartsOutsideAnyElement

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatNoTargetsAreSelected {
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

- (void)testThatNoConnectionsAreStarted {
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 0u,
                   @"expected connection count to be 0");
}

- (void)testThatColorButtonResponderIsAskedForATracker {
    XCTAssertNotEqual([self.colorButtonsTouchResponder.touchStartingPositions count],
                      0u, @"expected message count to be greater than 0");
}

- (void)testThatColorButtonResponderIsPassedTheInitialTouchPosition {
    XCTAssertEqualObjects(self.colorButtonsTouchResponder.touchStartingPositions[0],
                          POINT_OUTSIDE_ELEMENTS);
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutEnteringAnyElement : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutEnteringAnyElement

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidMoveTo:ANOTHER_POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatNoTargetsAreSelected {
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

- (void)testThatNoConnectionsAreStarted {
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 0u,
                   @"expected connection count to be 0");
}

- (void)testThatColorButtonTrackerReceivedNewPosition {
    XCTAssertTrue([self.colorButtonsTouchTracker.messagesReceived containsObject:
                          [[CTDMethodSelector alloc]
                           initWithRawSelector:@selector(touchDidMoveTo:)]]);
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchFirstMovesOntoATarget : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchFirstMovesOntoATarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidMoveTo:POINT_INSIDE_TARGET_1];
}

- (void)testThatTheTargetIsSelected {
    XCTAssertTrue([target1 isSelected]);
}

- (void)testThatNoOtherTargetsAreSelected {
    XCTAssertEqual([[self selectedTargets] count], 1u,
                   @"expected number of selected targets to be exactly 1");
}

- (void)testThatAConnectionIsStarted {
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 1u,
                   @"expected connection count to be 1");
}

- (void)testThatColorButtonTrackerWasCancelled {
    XCTAssertTrue([self colorButtonTrackerWasCancelled]);
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
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

- (void)testThatColorButtonTrackerIsNotifedThatTouchEnded {
    XCTAssertTrue([self colorButtonTrackerWasEnded]);
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
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

- (void)testThatColorButtonTrackerWasCancelled {
    XCTAssertTrue([self colorButtonTrackerWasCancelled]);
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
    XCTAssertTrue([target1 isSelected]);
}

- (void)testThatNoOtherTargetsAreSelected {
    XCTAssertEqual([[self selectedTargets] count], 1u,
                   @"expected number of selected targets to be exactly 1");
}

- (void)testThatAConnectionIsStarted {
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 1u,
                   @"expected connection count to be 1");
}

- (void)testThatTheFirstEndpointOfTheConnectionIsAnchoredToTheTargetConnectionPoint {
    XCTAssertEqualObjects([self activeConnection].firstEndpointPosition,
                          [target1 connectionPoint]);
}

- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPosition {
    XCTAssertEqualObjects([self activeConnection].secondEndpointPosition,
                          POINT_INSIDE_TARGET_1);
}

- (void)testThatColorButtonTrackerWasCancelled {
    XCTAssertTrue([self colorButtonTrackerWasCancelled]);
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialTarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialTarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
    [self.colorButtonsTouchTracker reset];
    [self.subject touchDidMoveTo:ANOTHER_POINT_INSIDE_TARGET_1];
}

- (void)testThatTheInitialTargetRemainsSelected {
    XCTAssertTrue([target1 isSelected]);
}

- (void)testThatNoOtherTargetBecomesSelected {
    XCTAssertEqual([[self selectedTargets] count], 1u,
                   @"expected number of selected targets to be exactly 1");
}

- (void)testThatTheFirstEndpointOfTheConnectionRemainsAnchoredToTheInitialTargetConnectionPoint {
    XCTAssertEqualObjects([self activeConnection].firstEndpointPosition,
                          [target1 connectionPoint]);
}

- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPosition {
    XCTAssertEqualObjects([self activeConnection].secondEndpointPosition,
                           ANOTHER_POINT_INSIDE_TARGET_1);
}

- (void)testThatNoNewConnectionsAreStarted {
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 1u,
                   @"expected connection count to be 1");
}

- (void)testThatColorButtonTrackerReceivedNoUpdates {
    XCTAssertEqual([self.colorButtonsTouchTracker.messagesReceived count], 0u);
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialTarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialTarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
    [self.colorButtonsTouchTracker reset];
    [self.subject touchDidMoveTo:POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatTheInitialTargetRemainsSelected {
    XCTAssertTrue([target1 isSelected]);
}

- (void)testThatNoOtherTargetsAreSelected {
    XCTAssertEqual([[self selectedTargets] count], 1u,
                   @"expected number of selected targets to be exactly 1");
}

- (void)testThatTheFirstEndpointOfTheConnectionRemainsAnchoredToTheInitialTargetConnectionPoint {
    XCTAssertEqualObjects([self activeConnection].firstEndpointPosition,
                          [target1 connectionPoint]);
}

- (void)testThatTheSecondEndpointOfTheConnectionFollowsTheTouchPosition {
    XCTAssertEqualObjects([self activeConnection].secondEndpointPosition,
                          POINT_OUTSIDE_ELEMENTS);
}

- (void)testThatNoNewConnectionsAreStarted {
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 1u,
                   @"expected connection count to be exactly 1");
}

- (void)testThatColorButtonTrackerReceivedNoUpdates {
    XCTAssertEqual([self.colorButtonsTouchTracker.messagesReceived count], 0u);
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinATarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinATarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
    [self.colorButtonsTouchTracker reset];
    [self.subject touchDidEnd];
}

- (void)testThatNoTargetsAreSelected {
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

//- (void)testThatTheConnectionIsDiscarded {
//    // TODO
//}

- (void)testThatColorButtonTrackerReceivedNoUpdates {
    XCTAssertEqual([self.colorButtonsTouchTracker.messagesReceived count], 0u);
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinATarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinATarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
    [self.colorButtonsTouchTracker reset];
    [self.subject touchWasCancelled];
}

- (void)testThatNoTargetsAreSelected {
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

//- (void)testThatTheConnectionIsDiscarded {
//    // TODO
//}

- (void)testThatColorButtonTrackerReceivedNoUpdates {
    XCTAssertEqual([self.colorButtonsTouchTracker.messagesReceived count], 0u);
}

@end




// TODO: CTDTrialSceneTouchTrackerTrackingFromATarget

