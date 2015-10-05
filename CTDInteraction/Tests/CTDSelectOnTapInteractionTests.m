// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectOnTapInteraction.h"

#import "Ports/CTDSelectionEditor.h"

#import "CTDColorCellsTestFixture.h"



// Marker values to differentiate from initial editor state (nil) and explicit
// clearing of highlighting or selection.
static NSString * const kHighlightingCleared = @"highlighting cleared";
static NSString * const kSelectionCleared = @"selection cleared";




@interface CTDSelectOnTapInteractionTestCase : XCTestCase <CTDSelectionEditor>

@property (strong, nonatomic) CTDSelectOnTapInteraction* subject;
@property (strong, nonatomic) CTDColorCellsTestFixture* fixture;
@property (copy, readonly, nonatomic) id highlightedElementId;
@property (copy, readonly, nonatomic) id selectedElementId;

@end

@implementation CTDSelectOnTapInteractionTestCase

- (void)setUp
{
    [super setUp];
    self.subject = nil;
    self.fixture = [[CTDColorCellsTestFixture alloc] init];
    _highlightedElementId = nil;
    _selectedElementId = nil;
}

- (void)createSubjectWithInitialPosition:(CTDPoint*)initialTouchPosition
{
    self.subject = [[CTDSelectOnTapInteraction alloc]
                    initWithSelectionEditor:self
                    touchMapper:self.fixture.colorCellTouchMapper
                    initialTouchPosition:initialTouchPosition];
}

- (void)highlightElementWithId:(id)elementId { _highlightedElementId = [elementId copy]; }
- (void)clearHighlighting { _highlightedElementId = kHighlightingCleared; }
- (void)selectElementWithId:(id)elementId { _selectedElementId = [elementId copy]; }
- (void)clearSelection { _selectedElementId = kSelectionCleared; }

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

- (void)testThatNoHighlightingWasDone
{
    assertThat(self.highlightedElementId, is(nilValue()));
}

- (void)testThatNoSelectionWasMade
{
    assertThat(self.selectedElementId, is(nilValue()));
}

@end




@interface CTDSelectOnTapInteractionWhenTouchMovesWithoutEnteringAnyElement
    : CTDSelectOnTapInteractionTestCase
@end
@implementation CTDSelectOnTapInteractionWhenTouchMovesWithoutEnteringAnyElement

- (void)setUp
{
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsOutsideElements[0]];
    [self.subject touchDidMoveTo:self.fixture.pointsOutsideElements[1]];
}

- (void)testThatNoHighlightingWasDone
{
    assertThat(self.highlightedElementId, is(nilValue()));
}

- (void)testThatNoSelectionWasMade
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

- (void)testThatTouchedCellIsHighlighted
{
    assertThat(self.highlightedElementId, is(equalTo(@1)));
}

- (void)testThatNoSelectionWasMade
{
    assertThat(self.selectedElementId, is(nilValue()));
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
    assertThat(self.selectedElementId, is(equalTo(@1)));
}

- (void)testThatTheHighlightingIsRemoved
{
    assertThat(self.highlightedElementId, is(kHighlightingCleared));
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

- (void)testThatTheHighlightingIsRemoved
{
    assertThat(self.highlightedElementId, is(kHighlightingCleared));
}

- (void)testThatNoSelectionWasMade
{
    assertThat(self.selectedElementId, is(nilValue()));
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

- (void)testThatTheHighlightingIsRemoved
{
    assertThat(self.highlightedElementId, is(kHighlightingCleared));
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

- (void)testThatNoSelectionWasMade
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

- (void)testThatNoSelectionWasMade
{
    assertThat(self.selectedElementId, is(nilValue()));
}

@end
