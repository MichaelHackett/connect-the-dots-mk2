// CTDConnectSceneViewController:
//     Controller for the main connect-the-dots scene.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDTargetView.h"
#import "CTDPresentation/CTDTouchResponder.h"


@interface CTDConnectSceneViewController
    : UIViewController <CTDTargetViewRenderer, CTDTouchInputSource>

@end
