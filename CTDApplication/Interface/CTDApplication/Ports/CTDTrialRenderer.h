// CTDTrialRenderer:
//     The visual representation of a connect-the-dots trial, containing a set
//     of dots and connections between them, plus the color selection tool.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "./CTDSelectionRenderer.h"

@class CTDPoint;



//
// Palette color labels
//
typedef NSString* CTDPaletteColorLabel;
extern CTDPaletteColorLabel const CTDPaletteColor_InactiveDot;
extern CTDPaletteColorLabel const CTDPaletteColor_DotType1;
extern CTDPaletteColorLabel const CTDPaletteColor_DotType2;
extern CTDPaletteColorLabel const CTDPaletteColor_DotType3;




@protocol CTDDotRenderer <CTDSelectionRenderer>

// This point is relative to the bounds of the dot container rendering.
- (CTDPoint*)dotConnectionPoint;

- (void)setDotColor:(CTDPaletteColorLabel)newDotColor;

// This is part of the child interface only because it avoids the situation
// where, if the container was asked to remove the dot rendering, it would only
// work with implementations that the container itself created, and it would
// have to verify that that was true. Here, the child will still have to ask
// the container for assistance, but it will be able to use native calls to
// do so.
//- (void)discardRendering; // don't even need this at the moment

@end



@protocol CTDDotConnectionRenderer <NSObject>

// Adjust the positions of the ends of the connection (point coordinates are
// relative to the display container).
- (void)setFirstEndpointPosition:(CTDPoint*)firstEndpointPosition;
- (void)setSecondEndpointPosition:(CTDPoint*)secondEndpointPosition;

// Remove the rendering from the display and do not allow its reuse.
- (void)discardRendering;

@end



@protocol CTDTrialRenderer <NSObject>

- (id<CTDDotRenderer>)
      newRendererForDotWithCenterPosition:(CTDPoint*)centerPosition
                             initialColor:(CTDPaletteColorLabel)dotColor;

- (id<CTDDotConnectionRenderer>)
      newRendererForDotConnectionWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                                    secondEndpointPosition:(CTDPoint*)secondEndpointPosition;

@end
