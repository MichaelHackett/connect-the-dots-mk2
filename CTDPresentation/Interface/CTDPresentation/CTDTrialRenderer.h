// CTDTrialRenderer:
//     The visual representation of a connect-the-dots trial, containing a set
//     of targets and connections between them, plus the color selection tool.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDColorPalette.h"

@protocol CTDTargetRenderer;
@protocol CTDTargetConnectionRenderer;
@protocol CTDTouchable;
@class CTDPoint;



@protocol CTDTrialRenderer <NSObject>

- (id<CTDTargetRenderer, CTDTouchable>)newTargetViewCenteredAt:(CTDPoint*)centerPosition
                                              withInitialColor:(CTDPaletteColor)targetColor;

- (id<CTDTargetConnectionRenderer>)
      newTargetConnectionViewWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                                secondEndpointPosition:(CTDPoint*)secondEndpointPosition;

@end
