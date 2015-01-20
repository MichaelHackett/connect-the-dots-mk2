// CTDUIKitDotSelectionIndicatorController:
//     Drives the visual indicator for when a dot has been selected.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@class CALayer;


@interface CTDUIKitDotSelectionIndicatorController : NSObject

- (id)init;

- (void)attachIndicatorToLayer:(CALayer*)hostLayer;
- (void)detachIndicator;

- (void)refreshIndicatorFrame;

- (void)showIndicator;
- (void)hideIndicator;

@end
