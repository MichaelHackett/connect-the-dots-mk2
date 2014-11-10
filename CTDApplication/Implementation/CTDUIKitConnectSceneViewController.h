// CTDUIKitConnectSceneViewController:
//     Controller for the main connect-the-dots scene.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDTouchResponder.h"
#import "CTDPresentation/CTDTrialRenderer.h"

@class CTDUIKitDrawingConfig;


@interface CTDUIKitConnectSceneViewController
    : UIViewController <CTDTrialRenderer, CTDTouchInputSource>

@property (copy, nonatomic) CTDUIKitDrawingConfig* drawingConfig;
@property (strong, readonly, nonatomic) NSDictionary* colorCellMap; // UIColor -> CTDKUIKitColorCell

@end
