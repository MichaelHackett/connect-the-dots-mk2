// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDConnectionActivity.h"
#import "Ports/CTDConnectScene.h"
#import "Ports/CTDDisplayController.h"

#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDModel.h"
#import "CTDModel/CTDTrial.h"
#import "CTDUtility/CTDPoint.h"



// Macro for defining sample data
#define step(COLOR,START,END) [[CTDDotPair alloc] initWithColor:(COLOR) startPosition:(START) endPosition:(END)]
#define dot(X,Y) [[CTDPoint alloc] initWithX:X y:Y]



@implementation CTDApplication
{
    id<CTDDisplayController> _displayController;
    id<CTDConnectScene> _connectionScene;
    CTDConnectionActivity* _connectionActivity;
}

- (id)initWithDisplayController:(id<CTDDisplayController>)displayController
{
    self = [super init];
    if (self) {
        _displayController = displayController;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD


- (void)start
{
    // TODO: Replace with data loaded from disk
    id<CTDTrial> trial = [CTDModel trialWithDotPairs:@[
        step(CTDDotColor_Green, dot(500,170), dot(200,400)),
        step(CTDDotColor_Red, dot(175,40), dot(350,75))
    ]];

    _connectionScene = [_displayController initialScene];
    _connectionActivity = [[CTDConnectionActivity alloc]
                           initWithTrial:trial
                           trialRenderer:_connectionScene.trialRenderer];
    [_connectionScene setTrialStepEditor:_connectionActivity];

    [_connectionActivity beginTrial];
}

@end
