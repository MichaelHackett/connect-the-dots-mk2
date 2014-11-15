// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectOnTapInteraction.h"

#import "CTDColorCellsTestFixture.h"
#import "CTDUtility/CTDPoint.h"



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
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsOutsideElements[0]];
}

- (void)testThatNoColorCellsAreSelected {
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
}

@end




@interface CTDSelectOnTapInteractionWhenTouchFirstMovesOntoAColorCell
    : CTDSelectOnTapInteractionBaseTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchFirstMovesOntoAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsOutsideElements[0]];
    [self.subject touchDidMoveTo:self.fixture.pointsInsideCell1[0]];
}

- (void)testThatNoColorCellsAreSelected {
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
}

@end




@interface CTDSelectOnTapInteractionWhenTouchEndsWhileWithinAColorCell
    : CTDSelectOnTapInteractionBaseTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchEndsWhileWithinAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell1[1]];
    [self.subject touchDidEnd];
}

- (void)testThatCellPreviouslyUnderTheTouchIsSelected {
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(YES));
}

- (void)testThatOtherColorCellsAreNotSelected {
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
}

@end




@interface CTDSelectOnTapInteractionWhenTouchIsCancelledWhileWithinAColorCell
    : CTDSelectOnTapInteractionBaseTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchIsCancelledWhileWithinAColorCell

- (void)setUp {
    [super setUp];
    self.subject = [self subjectWithInitialPosition:self.fixture.pointsInsideCell1[0]];
    if ([self.subject respondsToSelector:@selector(touchWasCancelled)]) {
        [self.subject touchWasCancelled];
    }
}

- (void)testThatNoColorCellsAreSelected {
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
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
    [self.subject touchDidEnd];
}

- (void)testThatNoColorCellsAreSelected {
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
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
    if ([self.subject respondsToSelector:@selector(touchWasCancelled)]) {
        [self.subject touchWasCancelled];
    }
}

- (void)testThatNoColorCellsAreSelected {
    assertThatBool(self.fixture.colorCell1.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell2.selected, equalToBool(NO));
    assertThatBool(self.fixture.colorCell3.selected, equalToBool(NO));
}

@end
