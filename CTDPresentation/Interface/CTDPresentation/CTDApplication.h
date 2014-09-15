// CTDApplication:
//     The main application controller.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTargetViewRenderer;


@interface CTDApplication : NSObject

- (void)showTargetSetInRenderer:(id<CTDTargetViewRenderer>)targetViewRenderer;

@end
