// CTDColorCellsTestFixture:
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

@protocol CTDTouchToElementMapper;



@interface CTDColorCellsTestFixture : NSObject

// Sets of generated points (3 for each list) that the touch mapper will map
// to the corresponding color cell (or to nothing, for the "outside" points).
@property (copy, nonatomic) NSArray* pointsInsideCell1;
@property (copy, nonatomic) NSArray* pointsInsideCell2;
@property (copy, nonatomic) NSArray* pointsInsideCell3;
@property (copy, nonatomic) NSArray* pointsOutsideElements;

// The IDs returned by the mapper are 1, 2, and 3, for the three cells.
@property (strong, nonatomic) id<CTDTouchToElementMapper> colorCellTouchMapper;

@end
