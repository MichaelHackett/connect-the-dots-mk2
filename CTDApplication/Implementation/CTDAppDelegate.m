// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDAppDelegate.h"

#import "CTDUIKitConnectSceneViewController.h"
#import "CTDUIKitDrawingConfig.h"
#import "CTDPresentation/CTDApplication.h"


static NSString* const kCTDConnectSceneViewControllerNibName =
          @"CTDConnectSceneViewController";



@implementation CTDAppDelegate
{
    UIWindow* _window;
    CTDApplication* _applicationController;
    CTDUIKitDrawingConfig* _drawingConfig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _applicationController = [[CTDApplication alloc] init];
    }
    return self;
}

// Override point for customization after application launch.
- (BOOL)application:(UIApplication*)application
        didFinishLaunchingWithOptions:(__unused NSDictionary*)launchOptions
{
    _drawingConfig = [[CTDUIKitDrawingConfig alloc] init];
    CTDUIKitConnectSceneViewController* initialViewController =
        [[CTDUIKitConnectSceneViewController alloc]
         initWithNibName:kCTDConnectSceneViewControllerNibName
                  bundle:nil];
    initialViewController.drawingConfig = _drawingConfig;

    application.statusBarHidden = YES;
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = initialViewController;
    [_window makeKeyAndVisible];

    [_applicationController showTargetSetInContainerView:initialViewController
                                    withTouchInputSource:initialViewController];

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
