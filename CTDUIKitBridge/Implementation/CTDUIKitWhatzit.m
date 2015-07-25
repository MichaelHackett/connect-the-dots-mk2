// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitWhatzit.h"

#import "CTDSceneBuilder.h"
#import "CTDUIKitColorPalette.h"
#import "CTDUIKitConnectSceneViewController.h"
#import "CTDUIKitDrawingConfig.h"
#import "CTDPresentation/CTDColorPalette.h"
#import "CocoaAdditions/UIKit.h"

// TEMPORARY
#import "CTDModel/CTDDot.h"
//#import "CTDModel/CTDDotColor.h"
#import "CTDModel/CTDModel.h"
#import "CTDModel/CTDTrial.h"
#import "CTDUtility/CTDPoint.h"



// NIB names
static NSString* const kCTDConnectSceneNibName = @"CTDUIKitConnectScene";


// Macro for defining sample data
#define dot(COLOR,X,Y) [[CTDDot alloc] initWithColor:COLOR position:[[CTDPoint alloc] initWithX:X y:Y]]



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

- (void)launchUI
{
    UIApplication* application = _application;
    application.statusBarHidden = YES;

    id<CTDConnectScene> connectScene =
        [[self class] connectSceneFromNibName:kCTDConnectSceneNibName
                            withDrawingConfig:_drawingConfig];

    _mainWindow =
        [UIKit fullScreenWindowWithRootViewController:connectScene.rootViewController
                                      backgroundColor:[UIColor whiteColor]];

    // TODO: Replace with data loaded from disk
    id<CTDTrial> trial = [CTDModel trialWithDots:@[
        dot(CTDDotColor_Green, 100, 170),
        dot(CTDDotColor_Red, 600, 400),
        dot(CTDDotColor_Blue, 250, 650)
    ]];

    // Now wire up the scene to the Presentation and Interaction modules.
    [CTDSceneBuilder prepareConnectScene:connectScene withTrial:trial];

    // Lastly, make it visible. (Have to do this after running the Scene
    // Builder, so that it has a chance to set some values before loading the
    // views. FIXME!)
    [_mainWindow makeKeyAndVisible];
}

+ (id<CTDConnectScene>)connectSceneFromNibName:(NSString*)connectSceneNibName
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
