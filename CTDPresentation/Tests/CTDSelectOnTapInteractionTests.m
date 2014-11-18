// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectOnTapInteraction.h"

#import "CTDColorCellsTestFixture.h"
#import "CTDSelectionChangeRecorder.h"
#import "CTDUtility/CTDPoint.h"

#define message CTDMakeMethodSelector




@interface CTDSelectOnTapInteractionBaseTestCase : XCTestCase
@property (strong, nonatomic) CTDSelectOnTapInteraction* subject;
@property (strong, nonatomic) CTDColorCellsTestFixture* fixture;
@end

@implementation CTDSelectOnTapInteractionBaseTestCase

- (void)setUp
{
    [super setUp];
    self.fixture = [[CTDColorCellsTestFixture alloc] init];
}

- (CTDSelectOnTapInteraction*)subjectWithInitialPosition:(CTDPoint*)initialTouchPosition
{
    return [[CTDSelectOnTapInteraction alloc]
            initWithTouchMapper:self.fixture.colorCellTouchMapper
            initialTouchPosition:initialTouchPosition];
}

@end



@interface CTDSelectOnTapInteractionWhenInitialPositionIsOutsideOfAllElements
    : CTDSelectOnTapInteractionBaseTestCase
@end
@implementation CTDSelectOnTapInteractionWhenInitialPositionIsOutsideOfAllElements

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




@interface CTDSelectOnTapInteractionWhenTouchFirstMovesOntoAColorCell
    : CTDSelectOnTapInteractionBaseTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchFirstMovesOntoAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsOutsideElements[0]];
    [self.fixture resetCellSelectionRecording];
    [self.subject touchDidMoveTo:self.fixture.pointsInsideCell1[0]];
}

- (void)testThatNoColorCellsReceivedSelectionChangeMessages {
    assertThat([self.fixture.colorCell1 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell2 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell3 messagesReceived], isEmpty());
}

@end




@interface CTDSelectOnTapInteractionWhenTouchEndsWhileWithinAColorCell
    : CTDSelectOnTapInteractionBaseTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchEndsWhileWithinAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell1[1]];
    [self.fixture resetCellSelectionRecording];
    if ([self.subject respondsToSelector:@selector(touchDidEnd)]) {
        [self.subject touchDidEnd];
    }
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




@interface CTDSelectOnTapInteractionWhenTouchIsCancelledWhileWithinAColorCell
    : CTDSelectOnTapInteractionBaseTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchIsCancelledWhileWithinAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell1[0]];
    [self.fixture resetCellSelectionRecording];
    if ([self.subject respondsToSelector:@selector(touchWasCancelled)]) {
        [self.subject touchWasCancelled];
    }
}

- (void)testThatNoColorCellsReceivedSelectionChangeMessages {
    assertThat([self.fixture.colorCell1 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell2 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell3 messagesReceived], isEmpty());
}

@end




@interface CTDSelectOnTapInteractionWhenTouchEndsWhileOutsideAnyColorCell
    : CTDSelectOnTapInteractionBaseTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchEndsWhileOutsideAnyColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell1[1]];
    [self.subject touchDidMoveTo:self.fixture.pointsOutsideElements[1]];
    [self.fixture resetCellSelectionRecording];
    if ([self.subject respondsToSelector:@selector(touchDidEnd)]) {
        [self.subject touchDidEnd];
    }
}

- (void)testThatNoColorCellsReceivedSelectionChangeMessages {
    assertThat([self.fixture.colorCell1 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell2 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell3 messagesReceived], isEmpty());
}

@end




@interface CTDSelectOnTapInteractionWhenTouchIsCancelledWhileOutsideAnyColorCell
    : CTDSelectOnTapInteractionBaseTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchIsCancelledWhileOutsideAnyColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell1[0]];
    [self.subject touchDidMoveTo:self.fixture.pointsOutsideElements[1]];
    [self.fixture resetCellSelectionRecording];
    if ([self.subject respondsToSelector:@selector(touchWasCancelled)]) {
        [self.subject touchWasCancelled];
    }
}

- (void)testThatNoColorCellsReceivedSelectionChangeMessages {
    assertThat([self.fixture.colorCell1 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell2 messagesReceived], isEmpty());
    assertThat([self.fixture.colorCell3 messagesReceived], isEmpty());
}

@end
