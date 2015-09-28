// Copyright 2015 Michael Hackett. All rights reserved.


/**
 * Processes user-input events related to the pre-trial menu scene.
 */
@protocol CTDTrialMenuSceneInputRouter <NSObject>

- (void)beginButtonPressed;
- (void)exitButtonPressed;

@end
