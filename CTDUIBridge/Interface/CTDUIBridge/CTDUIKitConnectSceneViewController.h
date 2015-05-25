// CTDUIKitConnectSceneViewController:
//     Controller for the main connect-the-dots scene.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitStandardViewController.h"
#import "CTDPresentation/CTDTrialRenderer.h"

@class CTDUIKitColorPalette;



@interface CTDUIKitConnectSceneViewController
    : CTDUIKitStandardViewController <CTDTrialRenderer>

// VC configuration (must be set before the container view is loaded, and
// changes made after view is loaded may have strange or no effects) --- fix?
@property (assign, nonatomic) float connectionLineWidth;
@property (copy, nonatomic) UIColor* connectionLineColor;
@property (copy, nonatomic) CTDUIKitColorPalette* colorPalette;

// maps CTDPaletteColorLabel -> CTDKUIKitColorCell
@property (strong, readonly, nonatomic) NSDictionary* colorCellMap;

@end
