// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDInMemoryTrialResults.h"



@implementation CTDInMemoryTrialResults
{
    NSMutableDictionary* _stepDurations;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _stepDurations = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setDuration:(NSTimeInterval)stepDuration
        forStepNumber:(NSUInteger)stepNumber
        startingDotPosition:(__unused CTDPoint*)startingDotPosition
        endingDotPosition:(__unused CTDPoint*)endingDotPosition
        connectionDuration:(__unused NSTimeInterval)connectionDuration
{
    _stepDurations[@(stepNumber)] = @(stepDuration);
}

- (NSTimeInterval)trialDuration
{
    double trialDuration = 0.0;
    for (NSNumber* stepDuration in [_stepDurations allValues])
    {
        trialDuration += [stepDuration doubleValue];
    }
    return (NSTimeInterval)trialDuration;
}

- (void)finalizeResults
{
    // TODO: Set a flag and check this in mutator methods, throwing an exception
    // if results are modified after finalization.
}

@end
