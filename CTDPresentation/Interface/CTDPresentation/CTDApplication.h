// CTDApplication:
//     The main application controller.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

@protocol CTDTouchInputRouter, CTDTrialRenderer;


@interface CTDApplication : NSObject

// The colorCellMap maps CTDPaletteColors (wrapped in NSNumbers) to objects
// that implement both CTDSelectionRenderer and CTDTouchable.
- (void)runTrialWithRenderer:(id<CTDTrialRenderer>)trialRenderer
                colorCellMap:(NSDictionary*)colorCellMap
            touchInputRouter:(id<CTDTouchInputRouter>)touchInputRouter;

@end
