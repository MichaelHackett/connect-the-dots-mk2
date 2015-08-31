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

- (void)setDuration:(double)stepDuration forStepNumber:(NSUInteger)stepNumber
{
    _stepDurations[@(stepNumber)] = @(stepDuration);
}

@end
