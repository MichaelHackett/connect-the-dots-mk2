// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDConnectionActivity.h"
#import "Ports/CTDConnectScene.h"
#import "Ports/CTDDisplayController.h"

#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDModel.h"
#import "CTDModel/CTDTrialScript.h"
#import "CTDUtility/CTDNotificationReceiver.h"
#import "CTDUtility/CTDPoint.h"
#import "CTDUtility/CTDRunLoopTimer.h"




// UI time intervals
static NSTimeInterval CTDTrialCompletionMessageDuration = 3.0;


// Macro for defining sample data
#define step(COLOR,START,END) [[CTDDotPair alloc] initWithColor:(COLOR) startPosition:(START) endPosition:(END)]
#define dot(X,Y) [[CTDPoint alloc] initWithX:X y:Y]



// TODO: Split to helper class, so as to avoid having private methods?
@interface CTDApplication () <CTDNotificationReceiver>
@end



@implementation CTDApplication
{
    id<CTDDisplayController> _displayController;
    id<CTDConnectScene> _connectionScene;
    CTDConnectionActivity* _connectionActivity;
    CTDRunLoopTimer* _displayTimer;
}

- (id)initWithDisplayController:(id<CTDDisplayController>)displayController
{
    self = [super init];
    if (self) {
        _displayController = displayController;
        _connectionScene = nil;
        _connectionActivity = nil;
        _displayTimer = nil;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD


- (void)start
{
    // TODO: Replace with data loaded from disk
    id<CTDTrialScript> trialScript = [CTDModel trialScriptWithDotPairs:@[
        step(CTDDotColor_Green, dot(500,170), dot(200,400)),
        step(CTDDotColor_Red, dot(175,40), dot(350,75))
    ]];

    _connectionScene = [_displayController initialScene];
    _connectionActivity = [[CTDConnectionActivity alloc]
                           initWithTrialScript:trialScript
                           trialRenderer:_connectionScene.trialRenderer
                           colorCellRenderers:[_connectionScene colorCellRendererMap]
                           trialCompletionNotificationReceiver:self];
    [_connectionActivity beginTrial];
    [_connectionScene setTrialEditor:_connectionActivity];
}

- (void)receiveNotification:(NSString*)notificationId
                 fromSender:(id)sender
                   withInfo:(__unused NSDictionary*)info
{
    if ([notificationId isEqualToString:CTDTrialCompletedNotification] && sender == _connectionActivity)
    {
        [_connectionScene displayTrialCompletionMessage];

        ctd_weakify(self, weakSelf);
        _displayTimer = [[CTDRunLoopTimer alloc]
                         initWithDuration:CTDTrialCompletionMessageDuration
                             onExpiration:
        ^{
            ctd_strongify(weakSelf, strongSelf);
            strongSelf->_displayTimer = nil;
            [strongSelf->_connectionScene hideTrialCompletionMessage];
        }];
    }
}

@end
