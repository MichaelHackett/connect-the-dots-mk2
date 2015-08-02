// CTDConnectionActivity:
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTrial;
@protocol CTDTrialRenderer;



@interface CTDConnectionActivity : NSObject

- (instancetype)initWithTrial:(id<CTDTrial>)trial
                trialRenderer:(id<CTDTrialRenderer>)trialRenderer;

CTD_NO_DEFAULT_INIT

- (void)beginTrial;

@end
