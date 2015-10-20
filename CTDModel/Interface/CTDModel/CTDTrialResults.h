// CTDTrialResults:
//     Captures the results of a participant's completion of a trial.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@class CTDPoint;



@protocol CTDTrialResults <NSObject>

// stepNumber is 1-based
- (void)setDuration:(NSTimeInterval)stepDuration
        forStepNumber:(NSUInteger)stepNumber
        startingDotPosition:(CTDPoint*)startingDotPosition
        endingDotPosition:(CTDPoint*)endingDotPosition
        connectionDuration:(NSTimeInterval)connectionDuration;

- (NSTimeInterval)trialDuration;

- (void)finalizeResults;

@end
