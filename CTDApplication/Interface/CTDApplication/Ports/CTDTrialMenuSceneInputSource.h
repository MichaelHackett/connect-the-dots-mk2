// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTrialMenuSceneInputRouter;



/**
 * A provider of input events for the pre-trial menu scene.
 */
@protocol CTDTrialMenuSceneInputSource <NSObject>

- (void)setTrialMenuSceneInputRouter:(id<CTDTrialMenuSceneInputRouter>)sceneInputRouter;

@end
