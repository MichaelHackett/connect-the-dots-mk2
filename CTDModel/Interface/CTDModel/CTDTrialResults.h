// CTDTrialResults:
//     Captures the results of a participant's completion of a trial.
//
// Copyright 2015 Michael Hackett. All rights reserved.


@protocol CTDTrialResults <NSObject>

// stepDuration is in seconds; stepNumber is 1-based
- (void)setDuration:(double)stepDuration forStepNumber:(NSUInteger)stepNumber;

@end
