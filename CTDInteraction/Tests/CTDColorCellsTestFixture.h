// CTDColorCellsTestFixture:
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTouchToElementMapper;
@class CTDSelectionChangeRecorder;



@interface CTDColorCellsTestFixture : NSObject

// TO BE REMOVED
@property (strong, readonly, nonatomic) CTDSelectionChangeRecorder* colorCell1;
@property (strong, readonly, nonatomic) CTDSelectionChangeRecorder* colorCell2;
@property (strong, readonly, nonatomic) CTDSelectionChangeRecorder* colorCell3;

// Sets of generated points (3 for each list) that the touch mapper will map
// to the corresponding color cell (or to nothing, for the "outside" points).
@property (copy, nonatomic) NSArray* pointsInsideCell1;
@property (copy, nonatomic) NSArray* pointsInsideCell2;
@property (copy, nonatomic) NSArray* pointsInsideCell3;
@property (copy, nonatomic) NSArray* pointsOutsideElements;

// The IDs returned by the mapper are 1, 2, and 3, for the three cells.
@property (strong, nonatomic) id<CTDTouchToElementMapper> colorCellTouchMapper;

// REMOVE?
- (void)resetCellSelectionRecording;

@end
