// CTDTrialRenderer:
//     The visual representation of a connect-the-dots trial, containing a set
//     of dots and connections between them, plus the color selection tool.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDColorPalette.h"

@protocol CTDDotRenderer;
@protocol CTDDotConnectionRenderer;
@protocol CTDTouchable;
@class CTDPoint;



@protocol CTDTrialRenderer <NSObject>

- (id<CTDDotRenderer, CTDTouchable>)newDotViewCenteredAt:(CTDPoint*)centerPosition
                                        withInitialColor:(CTDPaletteColor)dotColor;

- (id<CTDDotConnectionRenderer>)
      newDotConnectionViewWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                             secondEndpointPosition:(CTDPoint*)secondEndpointPosition;

@end
