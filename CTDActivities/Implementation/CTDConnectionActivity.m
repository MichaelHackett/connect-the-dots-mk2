// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDConnectionActivity.h"

#import "CTDColorMapping.h"
#import "CTDModel/CTDDot.h"
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
    CTDDot* startingDot = [_trial dotList][0];
    CTDDot* firstTargetDot = [_trial dotList][1];
    [_trialRenderer newDotRenderingCenteredAt:startingDot.position
                             withInitialColor:paletteColorForDotColor(startingDot.color)];
    [_trialRenderer newDotRenderingCenteredAt:firstTargetDot.position
                             withInitialColor:paletteColorForDotColor(firstTargetDot.color)];
}

@end
