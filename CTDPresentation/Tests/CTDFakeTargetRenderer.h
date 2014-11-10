// CTDFakeTargetRenderer:
//     A test spy to stand in for a target renderer.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTargetRenderer.h"
#import "CTDTouchable.h"
#import "CTDRecordingSelectionRenderer.h"

@class CTDPoint;



@interface CTDFakeTargetRenderer
    : CTDRecordingSelectionRenderer <CTDTargetRenderer, CTDTouchable>

@property (copy, readonly, nonatomic) CTDPoint* centerPosition;

- (instancetype)initWithCenterPosition:(CTDPoint*)centerPosition;
CTD_NO_DEFAULT_INIT

@end
