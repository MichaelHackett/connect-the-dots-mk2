// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitWhatzit.h"

#import "CTDSceneBuilder.h"
#import "CTDUIKitColorPalette.h"
#import "CTDUIKitConnectSceneViewController.h"
#import "CTDUIKitDrawingConfig.h"
#import "CTDPresentation/CTDColorPalette.h"
#import "CocoaAdditions/UIKit.h"



// NIB names
static NSString* const kCTDConnectSceneNibName = @"CTDUIKitConnectScene";



@implementation CTDUIKitWhatzit
{
    __weak UIApplication* _application;
    UIWindow* _mainWindow;
    CTDUIKitDrawingConfig* _drawingConfig;
}

- (instancetype)initWithApplication:(UIApplication*)application
{
    self = [super init];
    if (self) {
        _application = application;
        _mainWindow = nil;

        CTDUIKitDrawingConfig* drawingConfig = [[CTDUIKitDrawingConfig alloc] init];
        // TODO: Load these values from a plist or XML file.
        drawingConfig.colorPalette =
            [[CTDUIKitColorPalette alloc] initWithColorMap:@{
                CTDPaletteColor_InactiveDot: [UIColor whiteColor],
                CTDPaletteColor_DotType1:    [UIColor redColor],
                CTDPaletteColor_DotType2:    [UIColor greenColor],
                CTDPaletteColor_DotType3:    [UIColor blueColor]
            }];
        _drawingConfig = drawingConfig;
    }
    return self;
}

- (id<CTDConnectScene>)initialScene
{
    UIApplication* application = _application;
    application.statusBarHidden = YES;

    CTDUIKitConnectSceneViewController* connectScene = [self connectScene];
    _mainWindow = [UIKit fullScreenWindowWithRootViewController:connectScene
                                                backgroundColor:[UIColor whiteColor]];

    // Now wire up the scene to the Presentation and Interaction modules.
//    [CTDSceneBuilder prepareConnectScene:connectScene withTrial:trial];

    // Lastly, make it visible. (Have to do this after running the Scene
    // Builder, so that it has a chance to set some values before loading the
    // views. FIXME!)
    [_mainWindow makeKeyAndVisible];

    return connectScene;
}

- (CTDUIKitConnectSceneViewController*)connectScene
{
    CTDUIKitConnectSceneViewController* connectVC =
        [[CTDUIKitConnectSceneViewController alloc]
         initWithNibName:kCTDConnectSceneNibName
                  bundle:nil];
    connectVC.colorPalette = _drawingConfig.colorPalette;

    [connectVC view]; // force VC views to load; TODO: rewrite accessors to trigger load on demand

    return connectVC;
}

@end
