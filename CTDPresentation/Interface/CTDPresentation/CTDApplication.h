// CTDApplication:
//     The main application controller.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

@protocol CTDTrialRenderer, CTDTouchResponder;


@interface CTDApplication : NSObject

// The colorCellMap maps CTDPaletteColors (wrapped in NSNumbers) to objects
// that implement both CTDSelectionRenderer and CTDTouchable.
- (id<CTDTouchResponder>)
    newTrialPresenterWithRenderer:(id<CTDTrialRenderer>)trialRenderer
                     colorCellMap:(NSDictionary*)colorCellMap;

@end
