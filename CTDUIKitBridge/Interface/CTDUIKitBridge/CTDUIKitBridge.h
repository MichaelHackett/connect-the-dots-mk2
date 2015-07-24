// CTDUIKitBridge:
//     Gateway to UI Bridge module.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@class CTDUIKitDrawingConfig;
@protocol CTDConnectScene;


@interface CTDUIKitBridge : NSObject

+ (int)runApp;

+ (id<CTDConnectScene>)connectSceneFromNibName:(NSString*)connectSceneNibName
                             withDrawingConfig:(CTDUIKitDrawingConfig*)drawingConfig;

@end
