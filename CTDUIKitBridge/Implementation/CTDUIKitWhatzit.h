// CTDUIKitWhatzit:
//     I don't know what to call this yet, so I'm "naming it badly".
//     SetDresser? SceneBuilder? DisplayController?
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication/Ports/CTDDisplayController.h"

@class UIApplication;



@interface CTDUIKitWhatzit : NSObject <CTDDisplayController>

- (instancetype)initWithApplication:(UIApplication*)application;

@end
