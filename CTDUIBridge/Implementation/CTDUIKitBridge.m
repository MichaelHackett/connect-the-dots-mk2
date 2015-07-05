// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitBridge.h"

#import "CTDUIKitConnectSceneViewController.h"



@implementation CTDUIKitBridge

+ (CTDUIKitConnectSceneViewController*)
      connectSceneFromNibName:(NSString*)connectSceneNibName
{
    CTDUIKitConnectSceneViewController* connectVC =
        [[CTDUIKitConnectSceneViewController alloc]
         initWithNibName:connectSceneNibName
                  bundle:nil];

    [connectVC view]; // force VC views to load; TODO: rewrite accessors to trigger load on demand

    return connectVC;
}

@end
