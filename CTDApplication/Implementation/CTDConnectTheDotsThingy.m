// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDConnectTheDotsThingy.h"

#import "Ports/CTDConnectScene.h"

#import "CTDActivities/CTDConnectionActivity.h"
#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDModel.h"
#import "CTDModel/CTDTrial.h"
#import "CTDUtility/CTDPoint.h"



// Macro for defining sample data
#define step(COLOR,START,END) [[CTDDotPair alloc] initWithColor:(COLOR) startPosition:(START) endPosition:(END)]
#define dot(X,Y) [[CTDPoint alloc] initWithX:X y:Y]



@implementation CTDConnectTheDotsThingy
{
    CTDConnectionActivity* _connectionActivity;
}

+ (instancetype)prepareTrialScene:(id<CTDConnectScene>)connectScene
{
    // TODO: Replace with data loaded from disk
    id<CTDTrial> trial = [CTDModel trialWithDotPairs:@[
        step(CTDDotColor_Green, dot(500,170), dot(200,400)),
        step(CTDDotColor_Red, dot(175,40), dot(350,75))
    ]];

    CTDConnectionActivity* connectionActivity =
        [[CTDConnectionActivity alloc] initWithTrial:trial
                                       trialRenderer:connectScene.trialRenderer];

    CTDConnectTheDotsThingy* thingy = [[CTDConnectTheDotsThingy alloc]
                                       initWithConnectionActivity:connectionActivity];
    [connectScene setTrialStepEditor:thingy];

    return thingy;
}

- (instancetype)initWithConnectionActivity:(CTDConnectionActivity*)connectionActivity
{
    self = [super init];
    if (self) {
        _connectionActivity = connectionActivity;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD;

- (void)start
{
    [_connectionActivity beginTrial];
}



#pragma mark CTDTrialStepEditor protocol


- (void)beginConnection
{
    [_connectionActivity newConnection];
}

@end
