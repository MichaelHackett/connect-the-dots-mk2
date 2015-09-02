// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitWhatzit.h"

#import "CTDUIKitColorPalette.h"
#import "CTDUIKitConfigSceneViewController.h"
#import "CTDUIKitConnectSceneViewController.h"
#import "CTDUIKitDrawingConfig.h"
#import "CTDApplication/Ports/CTDTrialRenderer.h" // for CTDPaletteColor_xxx
#import "CocoaAdditions/UIKit.h"



// NIB names
static NSString* const kCTDConfigurationSceneNibName = @"CTDUIKitConfigScene";
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
    if (self)
    {
        _application = application;
        application.statusBarHidden = YES;
        _mainWindow = [UIKit fullScreenWindow];
        _mainWindow.backgroundColor = [UIColor whiteColor];
        [_mainWindow makeKeyAndVisible];

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

- (id<CTDConfigurationScene>)configurationScene
{
    CTDUIKitConfigSceneViewController* configVC =
        [[CTDUIKitConfigSceneViewController alloc]
         initWithNibName:kCTDConfigurationSceneNibName
                  bundle:nil];

    _mainWindow.rootViewController = configVC;

    return configVC;
}

- (id<CTDConnectScene>)connectScene
{
    CTDUIKitConnectSceneViewController* connectVC =
        [[CTDUIKitConnectSceneViewController alloc]
         initWithNibName:kCTDConnectSceneNibName
                  bundle:nil];
    connectVC.colorPalette = _drawingConfig.colorPalette;

    _mainWindow.rootViewController = connectVC;
    [connectVC view]; // force VC views to load; TODO: rewrite accessors to trigger load on demand

    return connectVC;
}

@end
