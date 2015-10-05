// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectOnTouchInteraction.h"

#import "Ports/CTDSelectionEditor.h"

#import "CTDColorCellsTestFixture.h"



// Marker values to differentiate from initial editor state (nil) and explicit
// clearing of highlighting or selection.
static NSString * const kHighlightingCleared = @"highlighting cleared";
static NSString * const kSelectionCleared = @"selection cleared";




@interface CTDSelectOnTouchInteractionTestCase : XCTestCase <CTDSelectionEditor>

@property (strong, nonatomic) CTDSelectOnTouchInteraction* subject;
@property (strong, nonatomic) CTDColorCellsTestFixture* fixture;
@property (copy, readonly, nonatomic) id highlightedElementId;
@property (copy, readonly, nonatomic) id selectedElementId;

@end

@implementation CTDSelectOnTouchInteractionTestCase

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
    self.subject = [[CTDSelectOnTouchInteraction alloc]
                    initWithSelectionEditor:self
                    touchMapper:self.fixture.colorCellTouchMapper
                    initialTouchPosition:initialTouchPosition];
}

- (void)highlightElementWithId:(id)elementId { _highlightedElementId = [elementId copy]; }
- (void)clearHighlighting { _highlightedElementId = kHighlightingCleared; }
- (void)selectElementWithId:(id)elementId { _selectedElementId = [elementId copy]; }
- (void)clearSelection { _selectedElementId = kSelectionCleared; }

@end




@interface CTDSelectOnTouchInteractionWhenInitialPositionIsOutsideOfAllElements
    : CTDSelectOnTouchInteractionTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenInitialPositionIsOutsideOfAllElements

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




@interface CTDSelectOnTouchInteractionWhenTouchMovesWithoutEnteringAnyElement
    : CTDSelectOnTouchInteractionTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchMovesWithoutEnteringAnyElement

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




@interface CTDSelectOnTouchInteractionWhenTouchFirstMovesOntoAColorCell
    : CTDSelectOnTouchInteractionTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchFirstMovesOntoAColorCell

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

- (void)testThatTouchedCellIsSelected
{
    assertThat(self.selectedElementId, is(equalTo(@1)));
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchStartsInsideAColorCell
    : CTDSelectOnTouchInteractionTestCase
@end

@implementation CTDSelectOnTouchInteractionWhenTouchStartsInsideAColorCell

- (void)setUp
{
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsInsideCell2[1]];
}

- (void)testThatTouchedCellIsHighlighted
{
    assertThat(self.highlightedElementId, is(equalTo(@2)));
}

- (void)testThatTouchedCellIsSelected
{
    assertThat(self.selectedElementId, is(equalTo(@2)));
}

@end




@interface CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialColorCell
    : CTDSelectOnTouchInteractionTestCase
@end
@implementation CTDTrialSceneTouchTrackerWhenTouchMovesWithoutLeavingTheInitialColorCell

- (void)setUp
{
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsInsideCell2[2]];
    [self.subject touchDidMoveTo:self.fixture.pointsInsideCell2[1]];
}

- (void)testThatTouchedCellRemainsHighlighted
{
    assertThat(self.highlightedElementId, is(equalTo(@2)));
}

- (void)testThatTouchedCellRemainsSelected
{
    assertThat(self.selectedElementId, is(equalTo(@2)));
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchMovesOffTheInitialColorCell
    : CTDSelectOnTouchInteractionTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchMovesOffTheInitialColorCell

- (void)setUp
{
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsInsideCell1[2]];
    [self.subject touchDidMoveTo:self.fixture.pointsOutsideElements[2]];
}

- (void)testThatElementHighlightingIsCleared
{
    assertThat(self.highlightedElementId, is(kHighlightingCleared));
}

- (void)testThatElementSelectionIsCleared
{
    assertThat(self.selectedElementId, is(kSelectionCleared));
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchMovesDirectlyFromOneColorCellToAnother
    : CTDSelectOnTouchInteractionTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchMovesDirectlyFromOneColorCellToAnother

- (void)setUp
{
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsInsideCell1[1]];
    [self.subject touchDidMoveTo:self.fixture.pointsInsideCell2[1]];
}

- (void)testThatNewlyTouchedCellIsHighlighted
{
    assertThat(self.highlightedElementId, is(equalTo(@2)));
}

- (void)testThatNewlyTouchedCellIsSelected
{
    assertThat(self.selectedElementId, is(equalTo(@2)));
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchEndsWhileWithinAColorCell
    : CTDSelectOnTouchInteractionTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchEndsWhileWithinAColorCell

- (void)setUp
{
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsInsideCell3[1]];
    if ([self.subject respondsToSelector:@selector(touchDidEnd)]) {
        [self.subject touchDidEnd];
    }
}

- (void)testThatElementHighlightingIsCleared
{
    assertThat(self.highlightedElementId, is(kHighlightingCleared));
}

- (void)testThatElementSelectionIsCleared
{
    assertThat(self.selectedElementId, is(kSelectionCleared));
}

@end




@interface CTDSelectOnTouchInteractionWhenTouchIsCancelledWhileWithinAColorCell
    : CTDSelectOnTouchInteractionTestCase
@end
@implementation CTDSelectOnTouchInteractionWhenTouchIsCancelledWhileWithinAColorCell
- (void)setUp
{
    [super setUp];
    [self createSubjectWithInitialPosition:self.fixture.pointsInsideCell2[0]];
    [self.subject touchWasCancelled];
}

- (void)testThatElementHighlightingIsCleared
{
    assertThat(self.highlightedElementId, is(kHighlightingCleared));
}

- (void)testThatElementSelectionIsCleared
{
    assertThat(self.selectedElementId, is(kSelectionCleared));
}

@end
