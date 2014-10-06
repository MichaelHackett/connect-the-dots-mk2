// CTDUIKitConnectSceneViewController:
//     Controller for the main connect-the-dots scene.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDTargetContainerView.h"
#import "CTDPresentation/CTDTouchResponder.h"

@class CTDUIKitDrawingConfig;


@interface CTDUIKitConnectSceneViewController
    : UIViewController <CTDTargetContainerView, CTDTouchInputSource>

@property (copy, nonatomic) CTDUIKitDrawingConfig* drawingConfig;

@end
