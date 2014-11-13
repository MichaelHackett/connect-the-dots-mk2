// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectOnTouchInteraction.h"

#import "CTDColorCellsTestFixture.h"
#import "CTDTouchMapper.h"
#import "CTDUtility/CTDPoint.h"
#import <XCTest/XCTest.h>




@interface CTDSelectOnTouchInteractionBaseTestCase : XCTestCase
@property (strong, nonatomic) CTDSelectOnTouchInteraction* subject;
@property (strong, nonatomic) CTDColorCellsTestFixture* fixture;
@end

@implementation CTDSelectOnTouchInteractionBaseTestCase

- (void)setUp
{
    [super setUp];
    self.fixture = [[CTDColorCellsTestFixture alloc] init];
}

- (CTDSelectOnTouchInteraction*)subjectWithInitialPosition:(CTDPoint*)initialTouchPosition
{
    return [[CTDSelectOnTouchInteraction alloc]
            initWithTouchMapper:self.fixture.colorCellTouchMapper
            initialTouchPosition:initialTouchPosition];
}

@end




@interface CTDSelectOnTouchInteractionWhenInitialPositionIsOutsideOfAllElements
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenInitialPositionIsOutsideOfAllElements

- (void)setUp {
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsOutsideElements[0]];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(self.fixture.colorCell1.selected);
    XCTAssertFalse(self.fixture.colorCell2.selected);
    XCTAssertFalse(self.fixture.colorCell3.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchMovesWithoutEnteringAnyElement
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchMovesWithoutEnteringAnyElement

- (void)setUp {
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsOutsideElements[0]];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(self.fixture.colorCell1.selected);
    XCTAssertFalse(self.fixture.colorCell2.selected);
    XCTAssertFalse(self.fixture.colorCell3.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchFirstMovesOntoAColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchFirstMovesOntoAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsOutsideElements[0]];
    [self.subject touchDidMoveTo:self.fixture.pointsInsideCell1[0]];
}

- (void)testThatTheColorCellUnderTheTouchIsSelected {
    XCTAssertTrue(self.fixture.colorCell1.selected);
}

- (void)testThatOtherColorCellsAreNotSelected {
    XCTAssertFalse(self.fixture.colorCell2.selected);
    XCTAssertFalse(self.fixture.colorCell3.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchStartsInsideAColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end

@implementation CTDSelectOnTouchInteractionWhenTouchStartsInsideAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell2[1]];
}

- (void)testThatTheCorrespondingColorCellIsSelected {
    XCTAssertTrue(self.fixture.colorCell2.selected);
}

- (void)testThatOtherColorCellsAreNotSelected {
    XCTAssertFalse(self.fixture.colorCell1.selected);
    XCTAssertFalse(self.fixture.colorCell3.selected);
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell2[2]];
    [self.subject touchDidMoveTo:self.fixture.pointsInsideCell2[1]];
}

- (void)testThatTheTargetedColorCellRemainsSelected {
    XCTAssertTrue(self.fixture.colorCell2.selected);
}

- (void)testThatOtherColorCellsAreNotSelected {
    XCTAssertFalse(self.fixture.colorCell1.selected);
    XCTAssertFalse(self.fixture.colorCell3.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchMovesOffTheInitialColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchMovesOffTheInitialColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell1[2]];
    [self.subject touchDidMoveTo:self.fixture.pointsOutsideElements[2]];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(self.fixture.colorCell1.selected);
    XCTAssertFalse(self.fixture.colorCell2.selected);
    XCTAssertFalse(self.fixture.colorCell3.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchMovesDirectlyFromOneColorCellToAnother
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchMovesDirectlyFromOneColorCellToAnother

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell1[1]];
    [self.subject touchDidMoveTo:self.fixture.pointsInsideCell2[1]];
}

- (void)testThatTheNewlyTargetedColorCellIsSelected {
    XCTAssertTrue(self.fixture.colorCell2.selected);
}

- (void)testThatTheFirstColorCellIsNoLongerSelected {
    XCTAssertFalse(self.fixture.colorCell1.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchEndsWhileWithinAColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchEndsWhileWithinAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell1[1]];
    [self.subject touchDidEnd];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(self.fixture.colorCell1.selected);
    XCTAssertFalse(self.fixture.colorCell2.selected);
    XCTAssertFalse(self.fixture.colorCell3.selected);
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchIsCancelledWhileWithinAColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchIsCancelledWhileWithinAColorCell
- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell2[0]];
    [self.subject touchWasCancelled];
}

- (void)testThatNoColorCellsAreSelected {
    XCTAssertFalse(self.fixture.colorCell1.selected);
    XCTAssertFalse(self.fixture.colorCell2.selected);
    XCTAssertFalse(self.fixture.colorCell3.selected);
}

@end
