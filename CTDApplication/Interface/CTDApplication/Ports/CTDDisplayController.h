// CTDDisplayController:
//     The interface to the host device's display controller, providing the
//     means to kick-start the application's UI.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDConnectScene;
@protocol CTDTaskConfigurationSceneInputSource;
@protocol CTDTaskConfigurationSceneRenderer;


@protocol CTDDisplayController <NSObject>

- (id<CTDTaskConfigurationSceneRenderer, CTDTaskConfigurationSceneInputSource>)
      taskConfigurationSceneBridge;
- (id<CTDConnectScene>)connectionSceneWithColorBarOnRight:(BOOL)colorBarOnRight
                                        quasimodalButtons:(BOOL)quasimodalButtons;
- (void)displayFatalError:(NSString*)message;

@end
