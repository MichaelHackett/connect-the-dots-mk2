// CTDColorCellsTestFixture:
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingColorCellRenderer.h"

@protocol CTDTouchMapper;



@interface CTDColorCellsTestFixture : NSObject

@property (strong, readonly, nonatomic) CTDRecordingColorCellRenderer* colorCell1;
@property (strong, readonly, nonatomic) CTDRecordingColorCellRenderer* colorCell2;
@property (strong, readonly, nonatomic) CTDRecordingColorCellRenderer* colorCell3;

// Sets of generated points (3 for each list) that the touch mapper will map
// to the corresponding color cell (or to nothing, for the "outside" points).
@property (copy, nonatomic) NSArray* pointsInsideCell1;
@property (copy, nonatomic) NSArray* pointsInsideCell2;
@property (copy, nonatomic) NSArray* pointsInsideCell3;
@property (copy, nonatomic) NSArray* pointsOutsideElements;

@property (strong, nonatomic) id<CTDTouchMapper> colorCellTouchMapper;

@end
