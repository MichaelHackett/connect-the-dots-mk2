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

//- (void)tearDown
//{
//    [super tearDown];
//}

@end




@interface CTDColorCellGroupInitialStateTestCase : CTDColorCellGroupBaseTestCase
@end
@implementation CTDColorCellGroupInitialStateTestCase

- (void)testThatSelectedColorSinkLastReceivesTheGroupDefaultColor {
    XCTAssertTrue(![self.selectedColor value] ||
                  [[self.selectedColor value] isEqualToNumber:@(DEFAULT_COLOR)]);
}

- (void)testThatAllCellsAreRenderedAsUnselected {
    XCTAssertFalse(self.redCellRenderer.selected);
    XCTAssertFalse(self.greenCellRenderer.selected);
    XCTAssertFalse(self.blueCellRenderer.selected);
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
    XCTAssertEqualObjects([self.selectedColor value], @(CTDTARGETCOLOR_RED));
}

- (void)testThatSelectedCellIsRenderedAsSelected {
    XCTAssertTrue(self.redCellRenderer.selected);
}

- (void)testThatOtherCellAreRenderedAsUnselected {
    XCTAssertFalse(self.greenCellRenderer.selected);
    XCTAssertFalse(self.blueCellRenderer.selected);
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
    XCTAssertEqualObjects([self.selectedColor value], @(CTDTARGETCOLOR_BLUE));
}

- (void)testThatBlueCellIsRenderedAsSelected {
    XCTAssertTrue(self.blueCellRenderer.selected);
}

- (void)testThatOtherCellsAreRenderedAsUnselected {
    XCTAssertFalse(self.redCellRenderer.selected);
    XCTAssertFalse(self.greenCellRenderer.selected);
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
    XCTAssertTrue(![self.selectedColor value] ||
                  [[self.selectedColor value] isEqualToNumber:@(DEFAULT_COLOR)]);
}

- (void)testThatAllCellsAreRenderedAsUnselected {
    XCTAssertFalse(self.redCellRenderer.selected);
    XCTAssertFalse(self.greenCellRenderer.selected);
    XCTAssertFalse(self.blueCellRenderer.selected);
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
    XCTAssertNil([self.selectedColor value],
                 @"received update: %u", [[self.selectedColor value] unsignedIntValue]);
}

- (void)testThatPreviouslySelectedCellIsStillRenderedAsSelected {
    XCTAssertTrue(self.greenCellRenderer.selected);
}

- (void)testThatOtherCellsAreStillRenderedAsUnselected {
    XCTAssertFalse(self.redCellRenderer.selected);
    XCTAssertFalse(self.blueCellRenderer.selected);
}

@end
