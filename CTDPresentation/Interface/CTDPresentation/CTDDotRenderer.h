// CTDDotRenderer:
//     An entity that renders a "dot" into another form (typically visual).
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDColorPalette.h"
#import "CTDSelectionRenderer.h"

@class CTDPoint;



@protocol CTDDotRenderer <CTDSelectionRenderer>

// This point is relative to the bounds of the dot container view.
- (CTDPoint*)connectionPoint;

- (void)changeDotColorTo:(CTDPaletteColorLabel)newDotColor;

// This is part of the child interface only because it avoids the situation
// where, if the container was asked to remove the dot view, it would only
// work with implementations that the container itself created, and it would
// have to verify that that was true. Here, the child will still have to ask
// the container for assistance, but it will be able to use native calls to
// do so.
//- (void)discardView; // don't even need this at the moment

@end



//@protocol CTDDotViewFactory <NSObject>
//
//- (id<CTDDotView>)newDotView;
//
//@end
