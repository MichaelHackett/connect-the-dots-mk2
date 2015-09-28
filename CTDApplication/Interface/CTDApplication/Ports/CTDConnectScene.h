// CTDConnectScene:
//     The application's interface to the Connection scene implementation.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTouchResponder;
@protocol CTDTouchToPointMapper;
@protocol CTDTrialEditor;
@protocol CTDTrialRenderer;
@protocol CTDTrialMenuSceneInputRouter;



@protocol CTDConnectScene <NSObject>

//- (void)setTouchResponder:(id<CTDTouchResponder>)touchResponder;
- (void)setTrialEditor:(id<CTDTrialEditor>)trialEditor;

- (id<CTDTrialRenderer>)trialRenderer;
//- (id<CTDTouchToPointMapper>)trialTouchMapper;
- (NSDictionary*)colorCellRendererMap; // of cellId -> id<CTDColorCellRenderer>

- (void)displayPreTrialMenuWithMessage:(NSString*)message
                           inputRouter:(id<CTDTrialMenuSceneInputRouter>)inputRouter;
- (void)hidePreTrialMenu;
- (void)displayTrialCompletionMessageWithTimeString:(NSString*)timeString;
- (void)hideTrialCompletionMessage;

@end
