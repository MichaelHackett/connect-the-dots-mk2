// CTDTaskConfigurationSceneInputRouter:
//     Processes user-input events related to the task-configuration scene.
//
// Copyright 2015 Michael Hackett. All rights reserved.


@protocol CTDTaskConfigurationSceneInputRouter <NSObject>

- (void)participantIdChangedTo:(NSUInteger)newParticipantId;
- (void)preferredHandChangedTo:(NSNumber*)newHandIndex;

- (void)formSubmissionButtonPressed;

@end
