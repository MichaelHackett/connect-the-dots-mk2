// CTDTrialResults:
//     Captures the results of a participant's completion of a trial.
//
// Copyright 2015 Michael Hackett. All rights reserved.


@protocol CTDTrialResults <NSObject>

// stepNumber is 1-based
- (void)setDuration:(NSTimeInterval)stepDuration forStepNumber:(NSUInteger)stepNumber;

- (NSTimeInterval)trialDuration;

@end
