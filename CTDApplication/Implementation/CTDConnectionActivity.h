// CTDConnectionActivity:
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTrialEditor.h"
@protocol CTDTrial;
@protocol CTDTrialRenderer;



@interface CTDConnectionActivity : NSObject <CTDTrialEditor>

- (instancetype)initWithTrial:(id<CTDTrial>)trial
                trialRenderer:(id<CTDTrialRenderer>)trialRenderer;

CTD_NO_DEFAULT_INIT

@end
