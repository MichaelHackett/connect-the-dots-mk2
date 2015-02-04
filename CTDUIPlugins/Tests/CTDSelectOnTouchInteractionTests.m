// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectOnTouchInteraction.h"

#import "CTDColorCellsTestFixture.h"
#import "CTDSelectionChangeRecorder.h"
#import "CTDTouchMapper.h"
#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"

#define message CTDMakeMethodSelector




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
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsOutsideElements[0]];
}

- (void)testThatNoColorCellsReceivedSelectionChangeMessages {
    assertThat([self.fixture.colorCell1 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell2 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell3 messagesReceived], isEmpty());
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchMovesWithoutEnteringAnyElement
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchMovesWithoutEnteringAnyElement

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsOutsideElements[0]];
}

- (void)testThatNoColorCellsReceivedSelectionChangeMessages {
    assertThat([self.fixture.colorCell1 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell2 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell3 messagesReceived], isEmpty());
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchFirstMovesOntoAColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchFirstMovesOntoAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsOutsideElements[0]];
    [self.fixture resetCellSelectionRecording];
    [self.subject touchDidMoveTo:self.fixture.pointsInsideCell1[0]];
}

- (void)testThatTheColorCellUnderTheTouchIsSelected {
    assertThat([self.fixture.colorCell1 messagesReceived],
               hasItem(message(select)));
}

- (void)testThatNoOtherColorCellsReceivedSelectionChangeMessages {
    assertThat([self.fixture.colorCell2 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell3 messagesReceived], isEmpty());
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

- (void)testThatTheColorCellUnderTheTouchIsSelected {
    assertThat([self.fixture.colorCell2 messagesReceived],
               hasItem(message(select)));
}

- (void)testThatNoOtherColorCellsReceivedSelectionChangeMessages {
    assertThat([self.fixture.colorCell1 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell3 messagesReceived], isEmpty());
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell2[2]];
    [self.fixture resetCellSelectionRecording];
    [self.subject touchDidMoveTo:self.fixture.pointsInsideCell2[1]];
}

- (void)testThatNoColorCellsReceivedSelectionChangeMessages {
    assertThat([self.fixture.colorCell1 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell2 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell3 messagesReceived], isEmpty());
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchMovesOffTheInitialColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchMovesOffTheInitialColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell1[2]];
    [self.fixture resetCellSelectionRecording];
    [self.subject touchDidMoveTo:self.fixture.pointsOutsideElements[2]];
}

- (void)testThatTheColorCellPreviouslyUnderTheTouchIsDeselected {
    assertThat([self.fixture.colorCell1 messagesReceived],
               hasItem(message(deselect)));
}

- (void)testThatNoOtherColorCellsReceivedSelectionChangeMessages {
    assertThat([self.fixture.colorCell2 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell3 messagesReceived], isEmpty());
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchMovesDirectlyFromOneColorCellToAnother
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchMovesDirectlyFromOneColorCellToAnother

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell1[1]];
    [self.fixture resetCellSelectionRecording];
    [self.subject touchDidMoveTo:self.fixture.pointsInsideCell2[1]];
}

- (void)testThatTheColorCellPreviouslyUnderTheTouchIsDeselected {
    assertThat([self.fixture.colorCell1 messagesReceived],
               hasItem(message(deselect)));
}

- (void)testThatTheColorCellNowUnderTheTouchIsSelected {
    assertThat([self.fixture.colorCell2 messagesReceived],
               hasItem(message(select)));
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchEndsWhileWithinAColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchEndsWhileWithinAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell3[1]];
    [self.fixture resetCellSelectionRecording];
    [self.subject touchDidEnd];
}

- (void)testThatTheColorCellPreviouslyUnderTheTouchIsDeselected {
    assertThat([self.fixture.colorCell3 messagesReceived],
               hasItem(message(deselect)));
}

- (void)testThatNoOtherColorCellsReceivedSelectionChangeMessages {
    assertThat([self.fixture.colorCell1 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell2 messagesReceived], isEmpty());
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchIsCancelledWhileWithinAColorCell
    : CTDSelectOnTouchInteractionBaseTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchIsCancelledWhileWithinAColorCell
- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell2[0]];
    [self.fixture resetCellSelectionRecording];
    [self.subject touchWasCancelled];
}

- (void)testThatTheColorCellPreviouslyUnderTheTouchIsDeselected {
    assertThat([self.fixture.colorCell2 messagesReceived],
               hasItem(message(deselect)));
}

- (void)testThatNoOtherColorCellsReceivedSelectionChangeMessages {
    assertThat([self.fixture.colorCell1 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell3 messagesReceived], isEmpty());
}


@end
