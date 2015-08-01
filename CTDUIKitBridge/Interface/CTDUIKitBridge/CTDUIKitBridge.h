// CTDUIKitBridge:
//     Gateway to UI Bridge module.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDDisplayController;



@interface CTDUIKitBridge : NSObject

+ (id<CTDDisplayController>)displayControllerForApplication:(UIApplication*)application;

@end
