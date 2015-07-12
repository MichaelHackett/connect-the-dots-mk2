// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitBridge.h"

#import "CTDUIKitConnectSceneViewController.h"
#import "CTDUIKitDrawingConfig.h"



@implementation CTDUIKitBridge

+ (CTDUIKitConnectSceneViewController*)
      connectSceneFromNibName:(NSString*)connectSceneNibName
            withDrawingConfig:(CTDUIKitDrawingConfig*)drawingConfig
{
    CTDUIKitConnectSceneViewController* connectVC =
        [[CTDUIKitConnectSceneViewController alloc]
         initWithNibName:connectSceneNibName
                  bundle:nil];
    connectVC.colorPalette = drawingConfig.colorPalette;

    [connectVC view]; // force VC views to load; TODO: rewrite accessors to trigger load on demand

    return connectVC;
}

@end
