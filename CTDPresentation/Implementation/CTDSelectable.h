// CTDSelectable:
//     An object that can be selected and deselected.
//
// Copyright 2014 Michael Hackett. All rights reserved.


@protocol CTDSelectable <NSObject>

- (void)select;
- (void)deselect;

@end
