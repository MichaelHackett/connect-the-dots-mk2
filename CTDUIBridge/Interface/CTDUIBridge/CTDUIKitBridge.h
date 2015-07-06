// CTDUIKitBridge:
//     Gateway to UI Bridge module.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@class CTDUIKitConnectSceneViewController;
@class CTDUIKitDrawingConfig;



@interface CTDUIKitBridge : NSObject

+ (CTDUIKitConnectSceneViewController*)
      connectSceneFromNibName:(NSString*)connectSceneNibName
            withDrawingConfig:(CTDUIKitDrawingConfig*)drawingConfig;

@end
