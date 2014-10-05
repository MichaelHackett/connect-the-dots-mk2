// CTDApplication:
//     The main application controller.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTargetViewRenderer, CTDTouchInputSource;


@interface CTDApplication : NSObject

- (void)showTargetSetInRenderer:(id<CTDTargetViewRenderer>)targetViewRenderer
           withTouchInputSource:(id<CTDTouchInputSource>)touchInputSource;

@end
