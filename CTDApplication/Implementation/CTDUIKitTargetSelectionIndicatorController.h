// CTDUIKitTargetSelectionIndicatorController:
//     Drives the visual indicator for when a target has been selected.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@class CALayer;


@interface CTDUIKitTargetSelectionIndicatorController : NSObject

- (id)init;

- (void)attachIndicatorToLayer:(CALayer*)hostLayer;
- (void)detachIndicator;

- (void)refreshIndicatorFrame;

- (void)showIndicator;
- (void)hideIndicator;

@end
