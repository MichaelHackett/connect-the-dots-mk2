// CTDTrialStepEditor:
//     Manipulator for one step in a trial.
//
// Copyright 2015 Michael Hackett. All rights reserved.



@protocol CTDTrialStepConnectionEditor <NSObject>

- (void)cancelConnection;

@end



@protocol CTDTrialStepEditor <NSObject>

// Create a new "live" connection, anchored at the current starting dot.
// (Note: Attempting to start a second connection while one is active will cancel the first one.)
- (id<CTDTrialStepConnectionEditor>)editorForNewConnection;

@end
