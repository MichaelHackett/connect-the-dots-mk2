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




@interface CTDTrialSceneTouchRouterBaseTestCase : XCTestCase
@property (strong, readonly, nonatomic) CTDTrialSceneTouchRouter* subject;
@property (strong, readonly, nonatomic) CTDRecordingTrialRenderer* trialRenderer;
@end

@implementation CTDTrialSceneTouchRouterBaseTestCase

- (void)setUp
{
    [super setUp];

    target1 = [[CTDFakeTargetRenderer alloc] initWithCenterPosition:TARGET_1_CENTER];
    colorCell1 = [[CTDRecordingColorCellRenderer alloc] init];
    colorCell2 = [[CTDRecordingColorCellRenderer alloc] init];

    _trialRenderer = [[CTDRecordingTrialRenderer alloc] init];
    _subject = [[CTDTrialSceneTouchRouter alloc]
                initWithTrialRenderer:_trialRenderer
                   targetsTouchMapper:[[CTDFakeTargetTouchMapper alloc] init]
              colorButtonsTouchMapper:[[CTDFakeColorButtonsTouchMapper alloc] init]];
}

- (void)tearDown
{
    _subject = nil;
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


// TODO: Split this case into one for each move

@interface CTDTrialSceneTouchTrackerStartingOutsideAnyElementTestCase
    : CTDTrialSceneTouchTrackerBaseTestCase
@end

@implementation CTDTrialSceneTouchTrackerStartingOutsideAnyElementTestCase

- (void)setUp
{
    [super setUp];
    self.touchTracker = [self.subject trackerForTouchStartingAt:POINT_OUTSIDE_ELEMENTS];
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

- (void)testThatNoColorCellsAreSelectedImmediately
{
    XCTAssertFalse(colorCell1.selected, @"expected color cell 1 to not be selected");
    XCTAssertFalse(colorCell2.selected, @"expected color cell 2 to not be selected");
}

- (void)testThatNoTargetBecomesSelectedWhenTheTouchMovesWithoutEnteringAnyElement
{
    [self.touchTracker touchDidMoveTo:ANOTHER_POINT_OUTSIDE_ELEMENTS];
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

- (void)testThatNoConnectionIsStartedWhenTheTouchMovesWithoutEnteringAnyElement
{
    [self.touchTracker touchDidMoveTo:ANOTHER_POINT_OUTSIDE_ELEMENTS];
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 0u,
                   @"expected connection count to be 0");
}

- (void)testThatNoColorCellsAreSelectedWhenTheTouchMovesWithoutEnteringAnyElement
{
    XCTAssertFalse(colorCell1.selected, @"expected color cell 1 to not be selected");
    XCTAssertFalse(colorCell2.selected, @"expected color cell 2 to not be selected");
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

- (void)testThatAColorCellBecomesSelectedWhenTheTouchMovesOntoIt
{
    [self.touchTracker touchDidMoveTo:POINT_INSIDE_COLOR_CELL_1];
    XCTAssertTrue(colorCell1.selected, @"expected color cell 1 to be selected");
}

- (void)testThatOtherColorCellsDoNotBecomeSelectedWhenTheTouchMovesOntoADifferentCell
{
    [self.touchTracker touchDidMoveTo:POINT_INSIDE_COLOR_CELL_1];
    XCTAssertFalse(colorCell2.selected, @"expected color cell 2 to not be selected");
}

- (void)testThatNoTargetBecomesSelectedWhenTheTouchMovesOntoAColorCell
{
    [self.touchTracker touchDidMoveTo:POINT_INSIDE_COLOR_CELL_1];
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

- (void)testThatNoConnectionIsStartedWhenTheTouchMovesOntoAColorCell
{
    [self.touchTracker touchDidMoveTo:POINT_INSIDE_COLOR_CELL_1];
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 0u,
                   @"expected connection count to be 0");
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

- (void)testThatNoColorCellsAreSelected
{
    XCTAssertFalse(colorCell1.selected, @"expected color cell 1 to not be selected");
    XCTAssertFalse(colorCell2.selected, @"expected color cell 2 to not be selected");
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
    [self.touchTracker touchDidMoveTo:POINT_OUTSIDE_ELEMENTS];
    XCTAssertTrue([target1 isSelected], @"expected target to be selected");
}

- (void)testThatNoOtherTargetBecomesSelectedWhenTheTouchMovesOffTheInitialTarget
{
    [self.touchTracker touchDidMoveTo:POINT_OUTSIDE_ELEMENTS];
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
    [self.touchTracker touchDidMoveTo:POINT_OUTSIDE_ELEMENTS];
    XCTAssertEqualObjects([self activeConnection].secondEndpointPosition,
                          POINT_OUTSIDE_ELEMENTS,
                          @"expected connection's second endpoint to equal the touch position");
}

- (void)testThatNoNewConnectionIsStartedWhenTheTouchMovesOffTheInitialTarget
{
    [self.touchTracker touchDidMoveTo:POINT_OUTSIDE_ELEMENTS];
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 1u,
                   @"expected connection count to be exactly 1");
}



// --- Touch ends ---

- (void)testThatTheInitialTargetBecomesUnselectedIfTheTouchEndsWhileWithinTheTarget
{
    [self.touchTracker touchDidEnd];
    XCTAssertFalse([target1 isSelected], @"expected target to be unselected");
}

//- (void)testThatTheConnectionIsDiscardedIfTheTouchEndsWhileWithinTheTarget
//{
//    [self.touchTracker touchDidEnd];
//    // TODO
//}



// --- Touch is cancelled ---

- (void)testThatTheInitialTargetBecomesUnselectedIfTheTouchIsCancelledWhileWithinTheTarget
{
    [self.touchTracker touchWasCancelled];
    XCTAssertFalse([target1 isSelected], @"expected target to be unselected");
}

//- (void)testThatTheConnectionIsDiscardedIfTheTouchIsCancelledWhileWithinTheTarget
//{
//    [self.touchTracker touchWasCancelled];
//    // TODO
//}

@end


// TODO: CTDTrialSceneTouchTrackerTrackingFromATarget




@interface CTDTrialSceneTouchTrackerStartingInsideAColorCell
    : CTDTrialSceneTouchTrackerBaseTestCase
@end

@implementation CTDTrialSceneTouchTrackerStartingInsideAColorCell

- (void)setUp
{
    [super setUp];
    self.touchTracker = [self.subject trackerForTouchStartingAt:POINT_INSIDE_COLOR_CELL_1];
}

- (void)testThatTheCorrespondingColorCellIsSelected
{
    XCTAssertTrue(colorCell1.selected, @"expected color cell 1 to be selected");
}

- (void)testThatOtherColorCellsAreNotSelected
{
    XCTAssertFalse(colorCell2.selected, @"expected color cell 2 to not be selected");
}

- (void)testThatNoTargetIsSelected
{
    XCTAssertEqual([[self selectedTargets] count], 0u,
                   @"expected number of selected targets to be 0");
}

- (void)testThatNoConnectionsHaveBeenStarted
{
    XCTAssertEqual([self.trialRenderer.targetConnectionViewsCreated count], 0u,
                   @"expected connection count to be 0");
}



// --- When the touch moves within the cell ---

- (void)testThatTheTargetedColorCellRemainsSelectedWhenTheTouchMovesWithoutLeavingTheCell
{
    [self.touchTracker touchDidMoveTo:ANOTHER_POINT_INSIDE_COLOR_CELL_1];
    XCTAssertTrue(colorCell1.selected, @"expected color cell 1 to be selected");
}

- (void)testThatOtherColorCellsAreNotSelectedWhenTheTouchMovesWithoutLeavingTheCell
{
    [self.touchTracker touchDidMoveTo:ANOTHER_POINT_INSIDE_COLOR_CELL_1];
    XCTAssertFalse(colorCell2.selected, @"expected color cell 2 to not be selected");
}




// --- When the touch leaves the cell ---

- (void)testThatAllColorCellsBecomeUnselectedWhenTheTouchLeavesTheInitialCell
{
    [self.touchTracker touchDidMoveTo:POINT_OUTSIDE_ELEMENTS];
    XCTAssertFalse(colorCell1.selected, @"expected color cell 1 to not be selected");
    XCTAssertFalse(colorCell2.selected, @"expected color cell 2 to not be selected");
}



// --- When the touch leaves the cell and immediately enters another cell ---

- (void)testThatTheNewlyTargetedColorCellBecomesSelectedWhenTheTouchMovesDirectlyToThatCell
{
    [self.touchTracker touchDidMoveTo:POINT_INSIDE_COLOR_CELL_2];
    XCTAssertTrue(colorCell2.selected, @"expected color cell 2 to be selected");
}

- (void)testThatOtherColorCellsAreNotSelectedWhenTheTouchMovesDirectlyToAnotherCell
{
    [self.touchTracker touchDidMoveTo:POINT_INSIDE_COLOR_CELL_2];
    XCTAssertFalse(colorCell1.selected, @"expected color cell 1 to not be selected");
}



// --- When the touch moves to a target ---

- (void)testThatAllColorCellsBecomeUnselectedWhenTheTouchMovesOntoATarget
{
    [self.touchTracker touchDidMoveTo:POINT_INSIDE_TARGET_1];
    XCTAssertFalse(colorCell1.selected, @"expected color cell 1 to not be selected");
    XCTAssertFalse(colorCell2.selected, @"expected color cell 2 to not be selected");
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




// --- When the touch ends while within a color cell ---

- (void)testThatAllColorCellsBecomesUnselectedIfTheTouchEndsWhileWithinACell
{
    [self.touchTracker touchDidEnd];
    XCTAssertFalse(colorCell1.selected, @"expected color cell 1 to not be selected");
    XCTAssertFalse(colorCell2.selected, @"expected color cell 2 to not be selected");
}



// --- Touch is cancelled ---

- (void)testThatTheInitialTargetBecomesUnselectedIfTheTouchIsCancelledWhileWithinTheTarget
{
    [self.touchTracker touchWasCancelled];
    XCTAssertFalse(colorCell1.selected, @"expected color cell 1 to not be selected");
    XCTAssertFalse(colorCell2.selected, @"expected color cell 2 to not be selected");
}

@end
