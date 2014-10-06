// CTDApplication:
//     The main application controller.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTargetContainerView, CTDTouchInputSource;


@interface CTDApplication : NSObject

- (void)showTargetSetInContainerView:(id<CTDTargetContainerView>)targetContainerView
                withTouchInputSource:(id<CTDTouchInputSource>)touchInputSource;

@end
