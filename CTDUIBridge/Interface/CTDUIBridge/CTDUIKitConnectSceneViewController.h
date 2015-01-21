// CTDUIKitConnectSceneViewController:
//     Controller for the main connect-the-dots scene.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDTouchResponder.h"
#import "CTDPresentation/CTDTrialRenderer.h"



@interface CTDUIKitConnectSceneViewController
    : UIViewController <CTDTrialRenderer, CTDTouchInputSource>

// VC configuration (must be set before the container view is loaded, and
// changed made after view is loaded will usually have no effect)
@property (assign, nonatomic) float connectionLineWidth;
@property (assign, nonatomic) CGColorRef connectionLineColor;
@property (copy, nonatomic) NSDictionary* dotColorMap; // @(CTDPaletteColor) -> UIColor*

// maps NSNumber(CTDPaletteColor) -> CTDKUIKitColorCell
@property (strong, readonly, nonatomic) NSDictionary* colorCellMap;

@end
