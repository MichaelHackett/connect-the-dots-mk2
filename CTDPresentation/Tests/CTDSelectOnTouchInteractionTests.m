// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectOnTouchInteraction.h"

#import "CTDRecordingColorCellRenderer.h"
#import "CTDTouchMapper.h"
#import "CTDUtility/CTDPoint.h"
#import <XCTest/XCTest.h>



#define point(XCOORD,YCOORD) [[CTDPoint alloc] initWithX:XCOORD y:YCOORD]

#define POINT_INSIDE_COLOR_CELL_1 point(300,40)
#define ANOTHER_POINT_INSIDE_COLOR_CELL_1 point(310,35)
#define POINT_INSIDE_COLOR_CELL_2 point(430,40)
#define POINT_OUTSIDE_ELEMENTS point(900,420)
#define ANOTHER_POINT_OUTSIDE_ELEMENTS point(140,650)



static CTDRecordingColorCellRenderer* colorCell1;
static CTDRecordingColorCellRenderer* colorCell2;
static CTDRecordingColorCellRenderer* colorCell3;



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




@interface CTDSelectOnTouchInteractionBaseTestCase : XCTestCase
@property (strong, nonatomic) CTDSelectOnTouchInteraction* subject;
@property (strong, nonatomic) id<CTDTouchMapper> colorCellTouchMapper;
@end

@implementation CTDSelectOnTouchInteractionBaseTestCase

- (void)setUp
{
    [super setUp];

    colorCell1 = [[CTDRecordingColorCellRenderer alloc] init];
    colorCell2 = [[CTDRecordingColorCellRenderer alloc] init];
    colorCell3 = [[CTDRecordingColorCellRenderer alloc] init];

    self.colorCellTouchMapper = [[CTDFakeColorButtonsTouchMapper alloc] init];
}

- (void)tearDown
{
    colorCell1 = nil;
    colorCell2 = nil;
    colorCell3 = nil;

    [super tearDown];
}

- (CTDSelectOnTouchInteraction*)subjectWithInitialPosition:(CTDPoint*)initialTouchPosition
{
    return [[CTDSelectOnTouchInteraction alloc]
            initWithTouchMapper:self.colorCellTouchMapper
            initialTouchPosition:initialTouchPosition];
}

@end




@interface CTDSelectOnTouchInteractionWhenInitialPositionIsOutsideOfAllElements
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenInitialPositionIsOutsideOfAllElements

- (void)setUp {
    self.subject = [self subjectWithInitialPosition:POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell2.selected);
    XCTAssertFalse(colorCell3.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchMovesWithoutEnteringAnyElement
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchMovesWithoutEnteringAnyElement

- (void)setUp {
    self.subject = [self subjectWithInitialPosition:POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell2.selected);
    XCTAssertFalse(colorCell3.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchFirstMovesOntoAColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchFirstMovesOntoAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidMoveTo:POINT_INSIDE_COLOR_CELL_1];
}

- (void)testThatTheColorCellUnderTheTouchIsSelected {
    XCTAssertTrue(colorCell1.selected);
}

- (void)testThatOtherColorCellsAreNotSelected {
    XCTAssertFalse(colorCell2.selected);
    XCTAssertFalse(colorCell3.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchStartsInsideAColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end

@implementation CTDSelectOnTouchInteractionWhenTouchStartsInsideAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:POINT_INSIDE_COLOR_CELL_2];
}

- (void)testThatTheCorrespondingColorCellIsSelected {
    XCTAssertTrue(colorCell2.selected);
}

- (void)testThatOtherColorCellsAreNotSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell3.selected);
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:POINT_INSIDE_COLOR_CELL_1];
    [self.subject touchDidMoveTo:ANOTHER_POINT_INSIDE_COLOR_CELL_1];
}

- (void)testThatTheTargetedColorCellRemainsSelected {
    XCTAssertTrue(colorCell1.selected);
}

- (void)testThatOtherColorCellsAreNotSelected {
    XCTAssertFalse(colorCell2.selected);
    XCTAssertFalse(colorCell3.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchMovesOffTheInitialColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchMovesOffTheInitialColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:POINT_INSIDE_COLOR_CELL_1];
    [self.subject touchDidMoveTo:POINT_OUTSIDE_ELEMENTS];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell2.selected);
    XCTAssertFalse(colorCell3.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchMovesDirectlyFromOneColorCellToAnother
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchMovesDirectlyFromOneColorCellToAnother

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:POINT_INSIDE_COLOR_CELL_1];
    [self.subject touchDidMoveTo:POINT_INSIDE_COLOR_CELL_2];
}

- (void)testThatTheNewlyTargetedColorCellIsSelected {
    XCTAssertTrue(colorCell2.selected);
}

- (void)testThatTheFirstColorCellIsNoLongerSelected {
    XCTAssertFalse(colorCell1.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchEndsWhileWithinAColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchEndsWhileWithinAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchDidEnd];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell2.selected);
    XCTAssertFalse(colorCell3.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchIsCancelledWhileWithinAColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchIsCancelledWhileWithinAColorCell
- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:POINT_OUTSIDE_ELEMENTS];
    [self.subject touchWasCancelled];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(colorCell1.selected);
    XCTAssertFalse(colorCell2.selected);
    XCTAssertFalse(colorCell3.selected);
}

@end
