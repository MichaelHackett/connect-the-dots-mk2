// CTDSceneFactory:
//     Convenience methods for creating and configuring the view controllers
//     for the application's "scenes".
//
// Copyright 2015 Michael Hackett. All rights reserved.

@class CTDUIKitConnectSceneViewController;
@class CTDUIKitDrawingConfig;



@interface CTDSceneFactory : NSObject

- (instancetype)initWithDrawingConfig:(CTDUIKitDrawingConfig*)drawingConfig;

CTD_NO_DEFAULT_INIT

- (CTDUIKitConnectSceneViewController*)connectScene;

@end
