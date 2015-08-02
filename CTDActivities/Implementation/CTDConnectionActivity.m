// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDConnectionActivity.h"

#import "CTDColorMapping.h"
#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDTrial.h"
#import "CTDPresentation/Ports/CTDTrialRenderer.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDConnectionActivity
{
    id<CTDTrial> _trial;
    id<CTDTrialRenderer> _trialRenderer;
}

- (instancetype)initWithTrial:(id<CTDTrial>)trial
                trialRenderer:(id<CTDTrialRenderer>)trialRenderer
{
    self = [super init];
    if (self) {
        _trial = trial;
        _trialRenderer = trialRenderer;
    }
    return self;
}

- (void)beginTrial
{
    CTDDotPair* firstStep = [_trial dotPairs][0];
    [_trialRenderer newDotRenderingCenteredAt:firstStep.startPosition
                             withInitialColor:paletteColorForDotColor(firstStep.color)];
}

@end
