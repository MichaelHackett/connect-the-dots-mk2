// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDConnectionActivity.h"
#import "Ports/CTDConnectScene.h"
#import "Ports/CTDDisplayController.h"

#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDModel.h"
#import "CTDModel/CTDTrialResults.h"
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
    id<CTDTimeSource> _timeSource;
    id<CTDTaskConfigurationSceneRenderer> _configurationSceneRenderer;
    id<CTDConnectScene> _connectionScene;
    CTDConnectionActivity* _connectionActivity;
    id<CTDTrialResults> _trialResults;
    CTDRunLoopTimer* _displayTimer;
}

- (id)initWithDisplayController:(id<CTDDisplayController>)displayController
                     timeSource:(id<CTDTimeSource>)timeSource
{
    self = [super init];
    if (self) {
        _displayController = displayController;
        _timeSource = timeSource;
        _configurationSceneRenderer = nil;
        _connectionScene = nil;
        _connectionActivity = nil;
        _trialResults = nil;
        _displayTimer = nil;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD


- (void)start
{
    [self displayConfigurationScreen];
}

- (void)displayConfigurationScreen
{
    _configurationSceneRenderer = [_displayController taskConfigurationSceneRenderer];
}

// TODO: Handle completion of configuration, release scene, and startTrial


- (void)startTrial
{
    // TODO: Replace with data loaded from disk
    id<CTDTrialScript> trialScript = [CTDModel trialScriptWithDotPairs:@[
        step(CTDDotColor_Green, dot(500,170), dot(200,400)),
        step(CTDDotColor_Red, dot(175,40), dot(350,75))
    ]];
    _trialResults = [CTDModel trialResultsHolder];

    _connectionScene = [_displayController connectScene];
    _connectionActivity = [[CTDConnectionActivity alloc]
                           initWithTrialScript:trialScript
                           trialResultsHolder:_trialResults
                           trialRenderer:_connectionScene.trialRenderer
                           colorCellRenderers:[_connectionScene colorCellRendererMap]
                           timeSource:_timeSource
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
        int trialDurationSeconds = (int)round((double)[_trialResults trialDuration]);
        NSString* timeString = [NSString stringWithFormat:@"%02d:%02d",
                                trialDurationSeconds / 60,
                                trialDurationSeconds % 60];
        [_connectionScene displayTrialCompletionMessageWithTimeString:timeString];

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
