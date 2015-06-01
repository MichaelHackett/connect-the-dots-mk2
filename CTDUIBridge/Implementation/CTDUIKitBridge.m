// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitBridge.h"

#import "CTDUIKitConnectSceneViewController.h"


static NSString* const kCTDUIKitBridgeConnectSceneViewControllerNibName =
          @"CTDUIKitConnectSceneViewController";



@implementation CTDUIKitBridge

+ (CTDUIKitConnectSceneViewController*)connectScene
{
    return [[CTDUIKitConnectSceneViewController alloc]
            initWithNibName:kCTDUIKitBridgeConnectSceneViewControllerNibName
                     bundle:nil];
}

@end
