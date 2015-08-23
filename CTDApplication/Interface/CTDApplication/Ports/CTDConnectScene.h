// CTDConnectScene:
//     The application's interface to the Connection scene implementation.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTouchResponder;
@protocol CTDTouchToPointMapper;
@protocol CTDTrialEditor;
@protocol CTDTrialRenderer;



@protocol CTDConnectScene <NSObject>

// - setColorPalette:(CTDUIKitColorPalette*)

- (void)setTouchResponder:(id<CTDTouchResponder>)touchResponder;
- (void)setTrialEditor:(id<CTDTrialEditor>)trialEditor;

- (id<CTDTrialRenderer>)trialRenderer;
- (id<CTDTouchToPointMapper>)trialTouchMapper;
- (NSArray *)colorSelectionCells; // of id<CTDSelectionRenderer, CTDTouchable>

- (void)displayTrialCompletionMessage;
- (void)hideTrialCompletionMessage;

@end
