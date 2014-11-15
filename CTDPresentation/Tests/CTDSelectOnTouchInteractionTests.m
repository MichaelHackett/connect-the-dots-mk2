// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectOnTouchInteraction.h"

#import "CTDColorCellsTestFixture.h"
#import "CTDTouchMapper.h"
#import "CTDUtility/CTDPoint.h"




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
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
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
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
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
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(YES));
}

- (void)testThatOtherColorCellsAreNotSelected {
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
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
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(YES));
}

- (void)testThatOtherColorCellsAreNotSelected {
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
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
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(YES));
}

- (void)testThatOtherColorCellsAreNotSelected {
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
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
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
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
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(YES));
}

- (void)testThatTheFirstColorCellIsNoLongerSelected {
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(NO));
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
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
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
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
}

@end
