// CTDSelectionRenderer:
//     Renders the presence or absence of some indicator that a UI element is
//     selected.
//
// Copyright 2014 Michael Hackett. All rights reserved.


@protocol CTDSelectionRenderer <NSObject>

- (void)showSelectionIndicator;
- (void)hideSelectionIndicator;

@end
