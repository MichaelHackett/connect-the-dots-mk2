// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectOnTapInteraction.h"

#import "Ports/CTDSelectionEditor.h"

#import "CTDColorCellsTestFixture.h"




@interface CTDSelectOnTapInteractionTestCase : XCTestCase <CTDSelectionEditor>

@property (strong, nonatomic) CTDSelectOnTapInteraction* subject;
@property (strong, nonatomic) CTDColorCellsTestFixture* fixture;
@property (copy, readonly, nonatomic) id selectedElementId;
@property (copy, readonly, nonatomic) id committedSelectionId;
@property (assign, readonly, nonatomic) BOOL selectionCancelled;

@end

@implementation CTDSelectOnTapInteractionTestCase

- (void)setUp
{
    [super setUp];
    self.subject = nil;
    self.fixture = [[CTDColorCellsTestFixture alloc] init];
    _selectedElementId = nil;
    _committedSelectionId = nil;
    _selectionCancelled = NO;
}

- (void)createSubjectWithInitialPosition:(CTDPoint*)initialTouchPosition
{
    self.subject = [[CTDSelectOnTapInteraction alloc]
                    initWithSelectionEditor:self
                    touchMapper:self.fixture.colorCellTouchMapper
                    initialTouchPosition:initialTouchPosition];
}

- (void)selectElementWithId:(id)elementId { _selectedElementId = [elementId copy]; }
- (void)clearSelection { _selectedElementId = nil; }
- (void)commitSelection { _committedSelectionId = _selectedElementId; }
- (void)cancelSelection { _selectionCancelled = YES; }

@end



@interface CTDSelectOnTapInteractionWhenInitialPositionIsOutsideOfAllElements
    : CTDSelectOnTapInteractionTestCase
@end
@implementation CTDSelectOnTapInteractionWhenInitialPositionIsOutsideOfAllElements

- (void)setUp
{
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsOutsideElements[0]];
}

- (void)testThatNoElementIsSelected
{
    assertThat(self.selectedElementId, is(nilValue()));
}

@end




@interface CTDSelectOnTapInteractionWhenTouchFirstMovesOntoAColorCell
    : CTDSelectOnTapInteractionTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchFirstMovesOntoAColorCell

- (void)setUp
{
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsOutsideElements[0]];
    [self.subject touchDidMoveTo:self.fixture.pointsInsideCell1[0]];
}

- (void)testThatTouchedCellIsSelectedInEditor
{
    assertThat(self.selectedElementId, is(equalTo(@1)));
}

@end




@interface CTDSelectOnTapInteractionWhenTouchEndsWhileWithinAColorCell
    : CTDSelectOnTapInteractionTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchEndsWhileWithinAColorCell

- (void)setUp
{
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsInsideCell1[1]];
    if ([self.subject respondsToSelector:@selector(touchDidEnd)]) {
        [self.subject touchDidEnd];
    }
}

- (void)testThatTheColorCellUnderTheTouchIsSelected
{
    assertThat(self.committedSelectionId, is(equalTo(@1)));
}

@end




@interface CTDSelectOnTapInteractionWhenTouchIsCancelledWhileWithinAColorCell
    : CTDSelectOnTapInteractionTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchIsCancelledWhileWithinAColorCell

- (void)setUp
{
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsInsideCell1[0]];
    if ([self.subject respondsToSelector:@selector(touchWasCancelled)]) {
        [self.subject touchWasCancelled];
    }
}

- (void)testThatEditorIsCancelled
{
    assertThatBool(self.selectionCancelled, is(equalToBool(YES)));
}

@end




@interface CTDSelectOnTapInteractionWhenTouchMovesOutsideAnyColorCell
    : CTDSelectOnTapInteractionTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchMovesOutsideAnyColorCell

- (void)setUp {
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsInsideCell1[1]];
    [self.subject touchDidMoveTo:self.fixture.pointsOutsideElements[1]];
}

- (void)testThatNoElementIsSelectedInEditor
{
    assertThat(self.selectedElementId, is(nilValue()));
}

@end




@interface CTDSelectOnTapInteractionWhenTouchEndsWhileOutsideAnyColorCell
    : CTDSelectOnTapInteractionTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchEndsWhileOutsideAnyColorCell

- (void)setUp {
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsInsideCell1[1]];
    [self.subject touchDidMoveTo:self.fixture.pointsOutsideElements[1]];
    if ([self.subject respondsToSelector:@selector(touchDidEnd)]) {
        [self.subject touchDidEnd];
    }
}

- (void)testThatEditorIsCancelled
{
    assertThatBool(self.selectionCancelled, is(equalToBool(YES)));
}

- (void)testThatNoCellIsSelected
{
    assertThat(self.selectedElementId, is(nilValue()));
}

@end




@interface CTDSelectOnTapInteractionWhenTouchIsCancelledWhileOutsideAnyColorCell
    : CTDSelectOnTapInteractionTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchIsCancelledWhileOutsideAnyColorCell

- (void)setUp {
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsInsideCell1[0]];
    [self.subject touchDidMoveTo:self.fixture.pointsOutsideElements[1]];
    if ([self.subject respondsToSelector:@selector(touchWasCancelled)]) {
        [self.subject touchWasCancelled];
    }
}

- (void)testThatEditorIsCancelled
{
    assertThatBool(self.selectionCancelled, is(equalToBool(YES)));
}

- (void)testThatNoCellIsSelected
{
    assertThat(self.selectedElementId, is(nilValue()));
}

@end
