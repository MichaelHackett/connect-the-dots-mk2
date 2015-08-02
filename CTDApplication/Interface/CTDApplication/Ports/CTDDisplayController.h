// CTDDisplayController:
//     The initial interface to the host device's display controller,
//     providing the means to kick-start the application's UI.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDConnectScene;


@protocol CTDDisplayController <NSObject>

- (id<CTDConnectScene>)initialScene;

@end
