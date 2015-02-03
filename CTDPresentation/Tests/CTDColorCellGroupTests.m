// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDColorCellGroup.h"

#import "CTDRecordingColorCellRenderer.h"
#import "CTDSelectable.h"
#import "CTDModel/CTDDotColor.h"

#import "CTDTestHelpers/CTDDidReceiveMessageMatcher.h"
#import "CTDUtility/CTDMethodSelector.h"

#define message CTDMakeMethodSelector




// Used as a CTDDotColorSink, a CTDColorCatcher retains all values sent to
// the sink, for checking in test assertions. When nothing has been received
// by the sink, the list will be empty.

@interface CTDColorCatcher : NSObject <CTDDotColorSink>
// Clear list of colors received.
- (void)reset;
@end

@implementation CTDColorCatcher
{
    NSMutableArray* _colorsReceived;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _colorsReceived = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)reset
{
    [_colorsReceived removeAllObjects];
}

- (void)colorChangedTo:(CTDDotColor)newColor
{
    [_colorsReceived addObject:@(newColor)];
}

- (NSArray*)colorsReceived
{
    return [_colorsReceived copy];
}

@end





// TODO: Could be generalized to just be about a selection mutex / single-selection
// set, dropping the irrelevant "cells" aspect.

static CTDDotColor const DEFAULT_COLOR = CTDDotColor_None;


@interface CTDColorCellGroupBaseTestCase : XCTestCase

// Test subject:
@property (strong, nonatomic) CTDColorCellGroup* subject;

// Input interfaces:
@property (strong, nonatomic) id<CTDSelectable> redCell;
@property (strong, nonatomic) id<CTDSelectable> greenCell;
@property (strong, nonatomic) id<CTDSelectable> blueCell;

// Outgoing messages capturing:
@property (strong, nonatomic) CTDRecordingColorCellRenderer* redCellRenderer;
@property (strong, nonatomic) CTDRecordingColorCellRenderer* greenCellRenderer;
@property (strong, nonatomic) CTDRecordingColorCellRenderer* blueCellRenderer;
@property (strong, nonatomic) CTDColorCatcher* selectedColor;

@end

@implementation CTDColorCellGroupBaseTestCase

- (void)setUp
{
    [super setUp];
    self.redCellRenderer = [[CTDRecordingColorCellRenderer alloc] init];
    self.greenCellRenderer = [[CTDRecordingColorCellRenderer alloc] init];
    self.blueCellRenderer = [[CTDRecordingColorCellRenderer alloc] init];
    self.selectedColor = [[CTDColorCatcher alloc] init];

    self.subject = [[CTDColorCellGroup alloc]
                    initWithDefaultColor:DEFAULT_COLOR
                       selectedColorSink:self.selectedColor];

    self.redCell = [self.subject addCellForColor:CTDDotColor_Red
                                    withRenderer:self.redCellRenderer];
    self.greenCell = [self.subject addCellForColor:CTDDotColor_Green
                                      withRenderer:self.greenCellRenderer];
    self.blueCell = [self.subject addCellForColor:CTDDotColor_Blue
                                     withRenderer:self.blueCellRenderer];
}

- (void)resetMessageRecording
{
    [self.redCellRenderer reset];
    [self.greenCellRenderer reset];
    [self.blueCellRenderer reset];
    [self.selectedColor reset];
}

// Apply test in all test cases below
- (void)testThatCellRenderersAreNotUpdatedMoreThanOnceEach
{
    assertThat([self.redCellRenderer selectionRenderingMesssagesReceived],
               hasCount(lessThanOrEqualTo(@1)));
    assertThat([self.greenCellRenderer selectionRenderingMesssagesReceived],
               hasCount(lessThanOrEqualTo(@1)));
    assertThat([self.blueCellRenderer selectionRenderingMesssagesReceived],
               hasCount(lessThanOrEqualTo(@1)));
}

@end




@interface CTDColorCellGroupInitialStateTestCase : CTDColorCellGroupBaseTestCase
@end
@implementation CTDColorCellGroupInitialStateTestCase

- (void)testThatSelectedColorSinkIsSentTheGroupDefaultColor
{
    assertThat([self.selectedColor colorsReceived],
               is(equalTo(@[@(DEFAULT_COLOR)])));
}

- (void)testThatAllCellRenderersAreNotifiedOfCellInitialSelectionState
{
    assertThat(self.redCellRenderer, receivedMessage(hideSelectionIndicator));
    assertThat(self.greenCellRenderer, receivedMessage(hideSelectionIndicator));
    assertThat(self.blueCellRenderer, receivedMessage(hideSelectionIndicator));
}

@end




@interface CTDColorCellGroupAfterFirstSelection : CTDColorCellGroupBaseTestCase
@end
@implementation CTDColorCellGroupAfterFirstSelection

- (void)setUp {
    [super setUp];
    [self resetMessageRecording];
    [self.redCell select];
}

- (void)testThatSelectedColorSinkIsSentTheSelectedCellColor {
    assertThat([self.selectedColor colorsReceived],
               is(equalTo(@[@(CTDDotColor_Red)])));
}

- (void)testThatSelectedCellIsRenderedAsSelected {
    assertThat(self.redCellRenderer, receivedMessage(showSelectionIndicator));
}

- (void)testThatOtherCellsAreNotRerendered {
    assertThat([self.greenCellRenderer selectionRenderingMesssagesReceived], isEmpty());
    assertThat([self.blueCellRenderer selectionRenderingMesssagesReceived], isEmpty());
}

@end




@interface CTDColorCellGroupAfterSecondSelection : CTDColorCellGroupBaseTestCase
@end
@implementation CTDColorCellGroupAfterSecondSelection

- (void)setUp {
    [super setUp];
    [self.redCell select];
    [self resetMessageRecording];
    [self.blueCell select];
}

- (void)testThatSelectedColorSinkIsSentTheColorOfTheLastCellSelected {
    assertThat([self.selectedColor colorsReceived],
               is(equalTo(@[@(CTDDotColor_Blue)])));
}

- (void)testThatTheNewlySelectedCellIsRenderedAsSelected {
    assertThat(self.blueCellRenderer, receivedMessage(showSelectionIndicator));
}

- (void)testThatThePreviouslySelectedCellIsRenderedAsUnselected {
    assertThat(self.redCellRenderer, receivedMessage(hideSelectionIndicator));
}

- (void)testThatOtherCellsAreNotRerendered {
    assertThat([self.greenCellRenderer selectionRenderingMesssagesReceived], isEmpty());
}

@end




@interface CTDColorCellGroupAfterDeselectingSelectedCell : CTDColorCellGroupBaseTestCase
@end
@implementation CTDColorCellGroupAfterDeselectingSelectedCell

- (void)setUp {
    [super setUp];
    [self.blueCell select];
    [self resetMessageRecording];
    [self.blueCell deselect];
}

- (void)testThatSelectedColorSinkIsSentTheGroupDefaultColor {
    assertThat([self.selectedColor colorsReceived],
               is(equalTo(@[@(DEFAULT_COLOR)])));
}

- (void)testThatThePreviouslySelectedCellIsRenderedAsUnselected {
    assertThat(self.blueCellRenderer, receivedMessage(hideSelectionIndicator));
}

- (void)testThatOtherCellsAreNotRerendered {
    assertThat([self.redCellRenderer selectionRenderingMesssagesReceived], isEmpty());
    assertThat([self.greenCellRenderer selectionRenderingMesssagesReceived], isEmpty());
}

@end




@interface CTDColorCellGroupAfterDeselectingAnUnselectedCell : CTDColorCellGroupBaseTestCase
@end
@implementation CTDColorCellGroupAfterDeselectingAnUnselectedCell

- (void)setUp {
    [super setUp];
    [self.greenCell select];
    [self resetMessageRecording];
    [self.blueCell deselect];
}

- (void)testThatSelectedColorSinkIsSentNoUpdates {
    assertThat([self.selectedColor colorsReceived], isEmpty());
}

- (void)testThatNoneOfTheCellRenderersReceiveAnyUpdates {
    assertThat([self.redCellRenderer selectionRenderingMesssagesReceived], isEmpty());
    assertThat([self.greenCellRenderer selectionRenderingMesssagesReceived], isEmpty());
    assertThat([self.blueCellRenderer selectionRenderingMesssagesReceived], isEmpty());
}

@end
