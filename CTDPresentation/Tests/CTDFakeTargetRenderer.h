// CTDFakeTargetRenderer:
//     A test spy to stand in for a target renderer.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDColorPalette.h"
#import "CTDTargetRenderer.h"
#import "CTDTouchable.h"
#import "CTDRecordingSelectionRenderer.h"

@class CTDPoint;



@interface CTDFakeTargetRenderer
    : CTDRecordingSelectionRenderer <CTDTargetRenderer, CTDTouchable>

@property (copy, readonly, nonatomic) CTDPoint* centerPosition;
@property (copy, readonly, nonatomic) NSArray* colorChanges;

- (instancetype)initWithCenterPosition:(CTDPoint*)centerPosition
                           targetColor:(CTDPaletteColor)targetColor;
CTD_NO_DEFAULT_INIT

@end
