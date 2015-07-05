// CTDSceneBuilder:
//     Creates Presentation and Interaction module elements for each of the
//     application's "scenes" (screens), and connects them to the UIKit views
//     and controllers.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@class CTDUIKitConnectSceneViewController;



@interface CTDSceneBuilder : NSObject

+ (void)prepareConnectScene:(CTDUIKitConnectSceneViewController*)connectVC;

@end
