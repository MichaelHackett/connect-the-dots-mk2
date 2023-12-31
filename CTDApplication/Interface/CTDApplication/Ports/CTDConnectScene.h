// CTDConnectScene:
//     The application's interface to the Connection scene implementation.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "../CTDDialogResponseHandler.h"
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

- (void)displayPreTrialMenuForTrialNumber:(NSInteger)trialNumber
                              inputRouter:(id<CTDTrialMenuSceneInputRouter>)inputRouter;
- (void)hidePreTrialMenu;
- (void)confirmExitWithResponseHandler:(CTDConfirmationResponseHandler)responseHandler;

- (void)displayTrialCompletionMessageWithTimeString:(NSString*)trialTimeString
                                     bestTimeString:(NSString*)bestTimeString;
- (void)hideTrialCompletionMessage;

- (void)displayTrialBlockCompletionMessageWithTrialCount:(NSUInteger)trialCount
                                         totalTimeString:(NSString*)timeString
        acknowledgementHandler:(CTDAcknowledgementResponseHandler)acknowledgementHandler;

@end
