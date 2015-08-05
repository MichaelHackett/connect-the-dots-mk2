// CTDConnectionActivity:
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTrialStepEditor.h"
@protocol CTDTrial;
@protocol CTDTrialRenderer;



@protocol CTDDotConnection <NSObject>

@end



@interface CTDConnectionActivity : NSObject <CTDTrialStepEditor>

- (instancetype)initWithTrial:(id<CTDTrial>)trial
                trialRenderer:(id<CTDTrialRenderer>)trialRenderer;

CTD_NO_DEFAULT_INIT

// Start the trial from the beginning.
- (void)beginTrial;

// Create a new "live" connection, anchored at the current starting dot.
- (id<CTDDotConnection>)newConnection;

@end
