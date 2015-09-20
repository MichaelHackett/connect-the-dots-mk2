// CTDTrialBlockResults:
//
// Copyright 2015 Michael Hackett. All rights reserved.



@protocol CTDTrialBlockResults <NSObject>

- (void)setDuration:(NSTimeInterval)trialDuration
     forTrialNumber:(NSUInteger)trialNumber
         sequenceId:(NSUInteger)sequenceId;

- (void)finalizeResults;

@end
