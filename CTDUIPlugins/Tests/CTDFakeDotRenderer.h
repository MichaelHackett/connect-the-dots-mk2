// CTDFakeDotRenderer:
//     A test spy to stand in for a dot renderer.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDColorPalette.h"
#import "CTDDotRenderer.h"
#import "CTDTouchable.h"
#import "CTDRecordingSelectionRenderer.h"

@class CTDPoint;



@interface CTDFakeDotRenderer
    : CTDRecordingSelectionRenderer <CTDDotRenderer, CTDTouchable>

@property (copy, readonly, nonatomic) CTDPoint* centerPosition;
@property (copy, readonly, nonatomic) NSArray* colorChanges;

- (instancetype)initWithCenterPosition:(CTDPoint*)centerPosition
                              dotColor:(CTDPaletteColor)dotColor;
CTD_NO_DEFAULT_INIT

@end
