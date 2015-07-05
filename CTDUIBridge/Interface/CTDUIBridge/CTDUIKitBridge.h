// CTDUIKitBridge:
//     Gateway to UI Bridge module.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@class CTDUIKitConnectSceneViewController;



@interface CTDUIKitBridge : NSObject

+ (CTDUIKitConnectSceneViewController*)
      connectSceneFromNibName:(NSString*)connectSceneNibName;

@end
