// CTDTrialEditor:
//     Manipulator for a trial.
//
// CTDTrialStepEditor:
//     Manipulator for one step in a trial.
//
// CTDTrialStepConnectionEditor:
//     Manipulator for a connection in a trial step.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@class CTDPoint;
@protocol CTDSelectionEditor;



@protocol CTDTrialStepConnectionEditor <NSObject>

// Note that setting the free-end position breaks any existing connection
// (though leaves the connection anchored to the first point).
- (void)setFreeEndPosition:(CTDPoint*)freeEndPosition;
- (void)establishConnection;
- (void)commitConnectionState;
- (void)cancelConnection;

@end



@protocol CTDTrialStepEditor <NSObject>

// Returns YES if the conditions for starting a connection (e.g., the matching
// color is selected) are in place.
- (BOOL)isConnectionAllowed;

// Create a new "live" connection, anchored at the current starting dot.
// Returns nil is `isConnectionAllowed` would currently return NO.
// (Note: Attempting to start a second connection while one is active will cancel the first one.)
- (id<CTDTrialStepConnectionEditor>)editorForNewConnection;

- (id)startingDotId;
- (id)endingDotId;

// Remove editor interface and prepare to be deallocated.
- (void)invalidate;

@end



@protocol CTDTrialEditor <NSObject>

- (void)beginTrial;
- (void)advanceToNextStep;

- (id<CTDTrialStepEditor>)editorForCurrentStep;
- (id<CTDSelectionEditor>)editorForColorSelection;

@end
