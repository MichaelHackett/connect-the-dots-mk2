// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTrialBlockCompletionSceneInputRouter;



/**
 * A provider of input events for the pre-trial menu scene.
 */
@protocol CTDTrialBlockCompletionSceneInputSource <NSObject>

- (void)setTrialBlockCompletionSceneInputRouter:
            (id<CTDTrialBlockCompletionSceneInputRouter>)sceneInputRouter;

@end
