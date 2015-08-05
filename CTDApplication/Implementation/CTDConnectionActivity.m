// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDConnectionActivity.h"

#import "CTDColorMapping.h"
#import "Ports/CTDTrialRenderer.h"

#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDTrial.h"
#import "CTDUtility/CTDPoint.h"



@interface CTDConnectionActivityDotConnection : NSObject <CTDDotConnection>

- (instancetype)initWithConnectionRenderer:(id<CTDDotConnectionRenderer>)connectionRenderer;
CTD_NO_DEFAULT_INIT

@end



@implementation CTDConnectionActivity
{
    id<CTDTrial> _trial;
    id<CTDTrialRenderer> _trialRenderer;
    id<CTDDotRenderer> _startingDotRenderer;
}

- (instancetype)initWithTrial:(id<CTDTrial>)trial
                trialRenderer:(id<CTDTrialRenderer>)trialRenderer
{
    self = [super init];
    if (self) {
        _trial = trial;
        _trialRenderer = trialRenderer;
        _startingDotRenderer = nil;
    }
    return self;
}

- (void)beginTrial
{
    CTDDotPair* firstStep = [_trial dotPairs][0];
    _startingDotRenderer =
        [_trialRenderer newRendererForDotWithCenterPosition:firstStep.startPosition
                                               initialColor:paletteColorForDotColor(firstStep.color)];
}

- (id<CTDDotConnection>)newConnection
{
    [_startingDotRenderer showSelectionIndicator];
    CTDDotPair* firstStep = [_trial dotPairs][0];
    [_trialRenderer newRendererForDotWithCenterPosition:firstStep.endPosition
                                           initialColor:paletteColorForDotColor(firstStep.color)];
    id<CTDDotConnectionRenderer> connectionRenderer =
        [_trialRenderer newRendererForDotConnectionWithFirstEndpointPosition:firstStep.startPosition
                                                      secondEndpointPosition:firstStep.startPosition];

    return [[CTDConnectionActivityDotConnection alloc]
            initWithConnectionRenderer:connectionRenderer];
}



#pragma mark CTDTrialStepEditor protocol

- (void)beginConnection
{
    [self newConnection];
}


@end




@implementation CTDConnectionActivityDotConnection
{
    id<CTDDotConnectionRenderer> _renderer;
}

- (instancetype)initWithConnectionRenderer:(id<CTDDotConnectionRenderer>)connectionRenderer
{
    self = [super init];
    if (self) {
        _renderer = connectionRenderer;
    }
    return self;
}

@end
