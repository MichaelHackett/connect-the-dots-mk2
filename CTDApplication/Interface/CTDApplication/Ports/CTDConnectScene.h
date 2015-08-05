// CTDConnectScene:
//     The application's interface to the Connection scene implementation.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTouchResponder;
@protocol CTDTouchToPointMapper;
@protocol CTDTrialRenderer;
@protocol CTDTrialStepEditor;



@protocol CTDConnectScene <NSObject>

// - setColorPalette:(CTDUIKitColorPalette*)

- (void)setTouchResponder:(id<CTDTouchResponder>)touchResponder;
- (void)setTrialStepEditor:(id<CTDTrialStepEditor>)trialStepEditor;

- (id<CTDTrialRenderer>)trialRenderer;
- (id<CTDTouchToPointMapper>)trialTouchMapper;
- (NSArray *)colorSelectionCells; // of id<CTDSelectionRenderer, CTDTouchable>

@end
