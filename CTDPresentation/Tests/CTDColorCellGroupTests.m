// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDColorCellGroup.h"

#import "CTDRecordingColorCellRenderer.h"
#import "CTDSelectable.h"
#import "CTDModel/CTDTargetColor.h"
#import <XCTest/XCTest.h>




// Used as a CTDTargetColorSink, a CTDColorCatcher retains the most recent
// value sent to the sink, so that it can later be checked by a test assertion.
// When nothing has been received by the sink, the last value will be nil.

@interface CTDColorCatcher : NSObject <CTDTargetColorSink>
// Reset value to nil, as if no value had been received.
- (void)reset;
@end

@implementation CTDColorCatcher
{
    NSNumber* _lastColorReceived;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastColorReceived = nil;
    }
    return self;
}

- (void)reset
{
    _lastColorReceived = nil;
}

- (void)colorChangedTo:(CTDTargetColor)newColor
{
    _lastColorReceived = @(newColor);
}

- (NSNumber*)value
{
    return _lastColorReceived;
}

@end





// TODO: Could be generalized to just be about a selection mutex / single-selection
// set, dropping the irrelevant "cells" aspect.

static CTDTargetColor const DEFAULT_COLOR = CTDTARGETCOLOR_NONE;


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

- (void)setUp {
    [super setUp];
    self.redCellRenderer = [[CTDRecordingColorCellRenderer alloc] init];
    self.greenCellRenderer = [[CTDRecordingColorCellRenderer alloc] init];
    self.blueCellRenderer = [[CTDRecordingColorCellRenderer alloc] init];
    self.selectedColor = [[CTDColorCatcher alloc] init];

    self.subject = [[CTDColorCellGroup alloc]
                    initWithDefaultColor:DEFAULT_COLOR
                       selectedColorSink:self.selectedColor];

    self.redCell = [self.subject addCellForColor:CTDTARGETCOLOR_RED
                                    withRenderer:self.redCellRenderer];
    self.greenCell = [self.subject addCellForColor:CTDTARGETCOLOR_GREEN
                                      withRenderer:self.greenCellRenderer];
    self.blueCell = [self.subject addCellForColor:CTDTARGETCOLOR_BLUE
                                     withRenderer:self.blueCellRenderer];
}

@end




@interface CTDColorCellGroupInitialStateTestCase : CTDColorCellGroupBaseTestCase
@end
@implementation CTDColorCellGroupInitialStateTestCase

- (void)testThatSelectedColorSinkLastReceivesTheGroupDefaultColor {
    assertThat([self.selectedColor value], is(equalTo(@(DEFAULT_COLOR))));
}

- (void)testThatAllCellsAreRenderedAsUnselected {
    assertThatBool(self.redCellRenderer.selected, is(equalToBool(NO)));
    assertThatBool(self.greenCellRenderer.selected, is(equalToBool(NO)));
    assertThatBool(self.blueCellRenderer.selected, is(equalToBool(NO)));
}

@end




@interface CTDColorCellGroupAfterFirstSelection : CTDColorCellGroupBaseTestCase
@end
@implementation CTDColorCellGroupAfterFirstSelection

- (void)setUp {
    [super setUp];
    [self.redCell select];
}

- (void)testThatSelectedColorSinkLastReceivesTheSelectedCellColor {
    assertThat([self.selectedColor value], is(equalTo(@(CTDTARGETCOLOR_RED))));
}

- (void)testThatSelectedCellIsRenderedAsSelected {
    assertThatBool(self.redCellRenderer.selected, is(equalToBool(YES)));
}

- (void)testThatOtherCellAreRenderedAsUnselected {
    assertThatBool(self.greenCellRenderer.selected, is(equalToBool(NO)));
    assertThatBool(self.blueCellRenderer.selected, is(equalToBool(NO)));
}

@end




@interface CTDColorCellGroupAfterSecondSelection : CTDColorCellGroupBaseTestCase
@end
@implementation CTDColorCellGroupAfterSecondSelection

- (void)setUp {
    [super setUp];
    [self.redCell select];
    [self.blueCell select];
}

- (void)testThatSelectedColorSinkLastReceivesTheColorOfTheLastCellSelected {
    assertThat([self.selectedColor value], is(equalTo(@(CTDTARGETCOLOR_BLUE))));
}

- (void)testThatBlueCellIsRenderedAsSelected {
    assertThatBool(self.blueCellRenderer.selected, is(equalToBool(YES)));
}

- (void)testThatOtherCellsAreRenderedAsUnselected {
    assertThatBool(self.redCellRenderer.selected, is(equalToBool(NO)));
    assertThatBool(self.greenCellRenderer.selected, is(equalToBool(NO)));
}

@end




@interface CTDColorCellGroupAfterDeselectingSelectedCell : CTDColorCellGroupBaseTestCase
@end
@implementation CTDColorCellGroupAfterDeselectingSelectedCell

- (void)setUp {
    [super setUp];
    [self.blueCell select];
    [self.blueCell deselect];
}

- (void)testThatSelectedColorSinkLastReceivesTheGroupDefaultColor {
    assertThat([self.selectedColor value], is(equalTo(@(DEFAULT_COLOR))));
}

- (void)testThatAllCellsAreRenderedAsUnselected {
    assertThatBool(self.redCellRenderer.selected, is(equalToBool(NO)));
    assertThatBool(self.greenCellRenderer.selected, is(equalToBool(NO)));
    assertThatBool(self.blueCellRenderer.selected, is(equalToBool(NO)));
}

@end




@interface CTDColorCellGroupAfterDeselectingAnUnselectedCell : CTDColorCellGroupBaseTestCase
@end
@implementation CTDColorCellGroupAfterDeselectingAnUnselectedCell

- (void)setUp {
    [super setUp];
    [self.greenCell select];
    [self.selectedColor reset];
    [self.blueCell deselect];
}

- (void)testThatSelectedColorSinkIsSentNoUpdates {
    assertThat([self.selectedColor value], is(nilValue()));
}

- (void)testThatPreviouslySelectedCellIsStillRenderedAsSelected {
    assertThatBool(self.greenCellRenderer.selected, is(equalToBool(YES)));
}

- (void)testThatOtherCellsAreStillRenderedAsUnselected {
    assertThatBool(self.redCellRenderer.selected, is(equalToBool(NO)));
    assertThatBool(self.blueCellRenderer.selected, is(equalToBool(NO)));
}

@end
