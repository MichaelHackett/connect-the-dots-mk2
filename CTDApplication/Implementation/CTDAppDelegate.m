// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDAppDelegate.h"

#import "CTDSceneBuilder.h"
#import "CTDUIBridge/CTDUIKitBridge.h"
#import "CTDUIBridge/CTDUIKitConnectSceneViewController.h"
#import "CTDUIBridge/CTDUIKitDrawingConfig.h"
#import "CTDUIBridge/CTDUIKitColorPalette.h"
#import "CocoaAdditions/UIKit.h"


static NSString* const kCTDConnectSceneNibName = @"CTDUIKitConnectScene";



@implementation CTDAppDelegate
{
    UIWindow* _window;
    CTDUIKitDrawingConfig* _drawingConfig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        CTDUIKitDrawingConfig* drawingConfig = [[CTDUIKitDrawingConfig alloc] init];
        // TODO: Load these values from a plist or XML file.
        drawingConfig.dotDiameter = 65.0;
        drawingConfig.dotSelectionIndicatorColor = [UIColor purpleColor];
        drawingConfig.dotSelectionIndicatorThickness = 3.0;
        drawingConfig.dotSelectionIndicatorPadding = 15.0;
        drawingConfig.dotSelectionAnimationDuration = (CGFloat)0.12;
        drawingConfig.connectionLineWidth = 5.0;
        drawingConfig.connectionLineColor = [UIColor yellowColor];
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

// Override point for customization after application launch.
- (BOOL)application:(UIApplication*)application
        didFinishLaunchingWithOptions:(__unused NSDictionary*)launchOptions
{
    // If we were using a storyboard, the window and initial view controller
    // would already be loaded at this point. To avoid disrupting other code
    // if/when we make that change, reproduce those steps here.
    application.statusBarHidden = YES;
    CTDUIKitConnectSceneViewController* connectVC =
        [CTDUIKitBridge connectSceneFromNibName:kCTDConnectSceneNibName
                              withDrawingConfig:_drawingConfig];
    _window = [UIKit fullScreenWindowWithRootViewController:connectVC
                                            backgroundColor:[UIColor whiteColor]];

    // Now wire up the scene to the Presentation and Interaction modules.
    [CTDSceneBuilder prepareConnectScene:connectVC];

    // Lastly, make it visible. (Have to do this after running the Scene
    // Builder, so that it has a chance to set some values before loading the
    // views. FIXME!)
    [_window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(__unused UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(__unused UIApplication*)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(__unused UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(__unused UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(__unused UIApplication*)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
