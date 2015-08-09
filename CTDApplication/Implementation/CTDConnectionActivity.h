// CTDConnectionActivity:
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTrialStepEditor.h"
@protocol CTDTrial;
@protocol CTDTrialRenderer;



@interface CTDConnectionActivity : NSObject

@property (strong, readonly, nonatomic) id<CTDTrialStepEditor> trialStepEditor;


- (instancetype)initWithTrial:(id<CTDTrial>)trial
                trialRenderer:(id<CTDTrialRenderer>)trialRenderer;

CTD_NO_DEFAULT_INIT

// Start the trial from the beginning.
- (void)beginTrial;

@end
