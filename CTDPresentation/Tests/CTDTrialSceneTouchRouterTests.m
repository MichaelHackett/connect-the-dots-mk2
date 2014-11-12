// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTrialSceneTouchRouter.h"

#import "CTDFakeTargetRenderer.h"
#import "CTDRecordingColorCellRenderer.h"
#import "CTDRecordingTargetConnectionView.h"
#import "CTDRecordingTrialRenderer.h"
#import "CTDTargetConnectionView.h"
#import "CTDTargetRenderer.h"
#import "CTDTouchMapper.h"
#import "CTDTrialRenderer.h"
#import "CTDUtility/CTDPoint.h"
#import <XCTest/XCTest.h>


#define point(XCOORD,YCOORD) [[CTDPoint alloc] initWithX:XCOORD y:YCOORD]

#define TARGET_1_CENTER point(40,96)
#define POINT_INSIDE_TARGET_1 point(45,99)
#define ANOTHER_POINT_INSIDE_TARGET_1 point(47,95)
#define POINT_INSIDE_COLOR_CELL_1 point(300,40)
#define ANOTHER_POINT_INSIDE_COLOR_CELL_1 point(310,35)
#define POINT_INSIDE_COLOR_CELL_2 point(430,40)
#define POINT_OUTSIDE_ELEMENTS point(22,70)
#define ANOTHER_POINT_OUTSIDE_ELEMENTS point(140,250)


static CTDFakeTargetRenderer* target1;

static CTDRecordingColorCellRenderer* colorCell1;
static CTDRecordingColorCellRenderer* colorCell2;




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


@interface CTDFakeColorButtonsTouchMapper : NSObject <CTDTouchMapper>
@end

@implementation CTDFakeColorButtonsTouchMapper

- (id)elementAtTouchLocation:(CTDPoint*)touchLocation
{
    if ([touchLocation isEqual:POINT_INSIDE_COLOR_CELL_1] ||
        [touchLocation isEqual:ANOTHER_POINT_INSIDE_COLOR_CELL_1])
    {
        return colorCell1;
    }
    else if ([touchLocation isEqual:POINT_INSIDE_COLOR_CELL_2])
    {
        return colorCell2;
    }
    return nil;
}

@end




@interface CTDTrialSceneTouchTrackerBaseTestCase : XCTestCase

// The tracker instantiated by the router (created in subclass test cases)
@property (strong, nonatomic) id<CTDTouchTracker> subject;

@property (strong, readonly, nonatomic) CTDTrialSceneTouchRouter* router;
@property (strong, readonly, nonatomic) CTDRecordingTrialRenderer* trialRenderer;

@end

@implementation CTDTrialSceneTouchTrackerBaseTestCase

- (void)setUp
{
    [super setUp];

    target1 = [[CTDFakeTargetRenderer alloc] initWithCenterPosition:TARGET_1_CENTER];
    colorCell1 = [[CTDRecordingColorCellRenderer alloc] init];
    colorCell2 = [[CTDRecordingColorCellRenderer alloc] init];

    _trialRenderer = [[CTDRecordingTrialRenderer alloc] init];
    _router = [[CTDTrialSceneTouchRouter alloc]
               initWithTrialRenderer:_trialRenderer
                  targetsTouchMapper:[[CTDFakeTargetTouchMapper alloc] init]
             colorButtonsTouchMapper:[[CTDFakeColorButtonsTouchMapper alloc] init]];
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

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell2.selected);
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

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell2.selected);
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

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell2.selected);
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

@end




@interface CTDTrialSceneTouchTrackerWhenTouchFirstMovesOntoAColorCell
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchFirstMovesOntoAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidMoveTo:POINT_INSIDE_COLOR_CELL_1];
}

- (void)testThatTheColorCellUnderTheTouchIsSelected {
    XCTAssertTrue(colorCell1.selected);
}

- (void)testThatOtherColorCellsAreNotSelected {
    XCTAssertFalse(colorCell2.selected);
}

- (void)testThatNoTargetsAreSelected {
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

- (void)testThatNoConnectionsAreStarted {
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 0u,
                   @"expected connection count to be 0");
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

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell2.selected);
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialTarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialTarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
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

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialTarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialTarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
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

@end




@interface CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinATarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinATarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
    [self.subject touchDidEnd];
}

- (void)testThatNoTargetsAreSelected {
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

//- (void)testThatTheConnectionIsDiscarded {
//    // TODO
//}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinATarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinATarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_TARGET_1];
    [self.subject touchWasCancelled];
}

- (void)testThatNoTargetsAreSelected {
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

//- (void)testThatTheConnectionIsDiscarded {
//    // TODO
//}

@end




// TODO: CTDTrialSceneTouchTrackerTrackingFromATarget




@interface CTDTrialSceneTouchTrackerWhenTouchStartsInsideAColorCell
    : CTDTrialSceneTouchTrackerBaseTestCase
@end

@implementation CTDTrialSceneTouchTrackerWhenTouchStartsInsideAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_COLOR_CELL_1];
}

- (void)testThatTheCorrespondingColorCellIsSelected {
    XCTAssertTrue(colorCell1.selected);
}

- (void)testThatOtherColorCellsAreNotSelected {
    XCTAssertFalse(colorCell2.selected);
}

- (void)testThatNoTargetsAreSelected {
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

- (void)testThatNoConnectionsHaveBeenStarted {
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 0u,
                   @"expected connection count to be 0");
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialColorCell
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_COLOR_CELL_1];
    [self.subject touchDidMoveTo:ANOTHER_POINT_INSIDE_COLOR_CELL_1];
}

- (void)testThatTheTargetedColorCellRemainsSelected {
    XCTAssertTrue(colorCell1.selected);
}

- (void)testThatOtherColorCellsAreNotSelected {
    XCTAssertFalse(colorCell2.selected);
}

- (void)testThatNoTargetsAreSelected {
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialColorCell
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesOffTheInitialColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_COLOR_CELL_1];
    [self.subject touchDidMoveTo:POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell2.selected);
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesDirectlyFromOneColorCellToAnother
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesDirectlyFromOneColorCellToAnother

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_COLOR_CELL_1];
    [self.subject touchDidMoveTo:POINT_INSIDE_COLOR_CELL_2];
}

- (void)testThatTheNewlyTargetedColorCellIsSelected {
    XCTAssertTrue(colorCell2.selected);
}

- (void)testThatTheFirstColorCellIsNoLongerSelected {
    XCTAssertFalse(colorCell1.selected);
}

@end




// --- When the touch moves to a target ---

@interface CTDTrialSceneTouchTrackerWhenTouchMovesDirectlyFromAColorCellToATarget
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesDirectlyFromAColorCellToATarget

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_COLOR_CELL_1];
    [self.subject touchDidMoveTo:POINT_INSIDE_TARGET_1];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell2.selected);
}

- (void)testThatTheTargetUnderTheNewTouchPositionIsSelected {
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

@end




@interface CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinAColorCell
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchEndsWhileWithinAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_COLOR_CELL_1];
    [self.subject touchDidEnd];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell2.selected);
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinAColorCell
    : CTDTrialSceneTouchTrackerBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchIsCancelledWhileWithinAColorCell
- (void)setUp {
    [super setUp];
    self.subject = [self.router trackerForTouchStartingAt:POINT_INSIDE_COLOR_CELL_1];
    [self.subject touchWasCancelled];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell2.selected);
}

@end
