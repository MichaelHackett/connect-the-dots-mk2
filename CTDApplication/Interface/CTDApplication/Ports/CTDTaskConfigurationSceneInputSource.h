// CTDTaskConfigurationSceneInputSource:
//     A provider of input events for the task configuration scene.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTaskConfigurationSceneInputRouter;


@protocol CTDTaskConfigurationSceneInputSource <NSObject>

- (void)setTaskConfigurationSceneInputRouter:
      (id<CTDTaskConfigurationSceneInputRouter>)sceneInputRouter;

@end
