// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDAppDelegate.h"

#import "Ports/CTDConnectScene.h"
#import "Ports/CTDDisplayController.h"

#import "CTDActivities/CTDConnectionActivity.h"
#import "CTDModel/CTDDot.h"
#import "CTDModel/CTDModel.h"
#import "CTDModel/CTDTrial.h"
#import "CTDUIKitBridge/CTDUIKitBridge.h"
#import "CTDUtility/CTDPoint.h"



// Macro for defining sample data
#define dot(COLOR,X,Y) [[CTDDot alloc] initWithColor:COLOR position:[[CTDPoint alloc] initWithX:X y:Y]]



@implementation CTDAppDelegate
{
    id<CTDDisplayController> _displayController;
}

// Override point for customization after application launch.
- (BOOL)application:(UIApplication*)application
        didFinishLaunchingWithOptions:(__unused NSDictionary*)launchOptions
{
    _displayController = [CTDUIKitBridge displayControllerForApplication:application];
    id<CTDConnectScene> connectScene = [_displayController initialScene];

    // TODO: Replace with data loaded from disk
    id<CTDTrial> trial = [CTDModel trialWithDots:@[
        dot(CTDDotColor_Green, 500, 170),
        dot(CTDDotColor_Red, 200, 400),
        dot(CTDDotColor_Blue, 250, 650)
    ]];

    CTDConnectionActivity* connectionActivity =
        [[CTDConnectionActivity alloc] initWithTrial:trial
                                       trialRenderer:connectScene.trialRenderer];
    [connectionActivity beginTrial];

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
