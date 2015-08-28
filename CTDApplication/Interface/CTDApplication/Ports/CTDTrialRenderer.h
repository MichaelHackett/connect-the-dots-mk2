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




// Note that DotRenderings and DotConnectionRenderings are not visible until
// explicitly shown.
// (TODO: Make this consistent across all Rendering interfaces?)

@protocol CTDDotRenderer <CTDSelectionRenderer>

- (void)setDotCenterPosition:(CTDPoint*)centerPosition;
- (void)setDotColor:(CTDPaletteColorLabel)newDotColor;
- (void)setVisible:(BOOL)visible;

// Remove rendering permanently and discards any native-level components
// associated with it.
- (void)discardRendering;

// This point is relative to the bounds of the dot container rendering.
- (CTDPoint*)dotConnectionPoint;

@end



@protocol CTDDotConnectionRenderer <NSObject>

// Adjust the positions of the ends of the connection (point coordinates are
// relative to the display container).
- (void)setFirstEndpointPosition:(CTDPoint*)firstEndpointPosition;
- (void)setSecondEndpointPosition:(CTDPoint*)secondEndpointPosition;

- (void)setVisible:(BOOL)visible;

// Remove the rendering from the display and do not allow its reuse.
- (void)discardRendering;

@end



@protocol CTDTrialRenderer <NSObject>

- (id<CTDDotRenderer>)newRendererForDotWithId:(id)dotId;
- (id<CTDDotConnectionRenderer>)newRendererForDotConnection;

@end
