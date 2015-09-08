// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDConnectionActivity.h"
#import "CTDTaskConfiguration.h"
#import "CTDTaskConfigurationActivity.h"
#import "CTDTaskConfigurationScene.h"
#import "Ports/CTDConnectScene.h"
#import "Ports/CTDDisplayController.h"
#import "Ports/CTDTaskConfigurationSceneInputSource.h"
#import "Ports/CTDTaskConfigurationSceneRenderer.h"

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
#define dot(X,Y) [[CTDPoint alloc] initWithX:(CTDPointCoordinate)X y:(CTDPointCoordinate)Y]



// TODO: Split into helper class, so as to avoid having private methods?
@interface CTDApplication () <CTDNotificationReceiver, CTDTaskConfiguration>
@end



@implementation CTDApplication
{
    id<CTDDisplayController> _displayController;
    id<CTDTimeSource> _timeSource;
    CTDTaskConfigurationActivity* _configurationActivity;
    CTDTaskConfigurationScene* _configurationScene;
    id<CTDConnectScene> _connectionScene;
    CTDConnectionActivity* _connectionActivity;
    id<CTDTrialResults> _trialResults;
    CTDRunLoopTimer* _displayTimer;

    // Task configuration
    NSUInteger _participantId;
    CTDHand _preferredHand;
    CTDInterfaceStyle _interfaceStyle;
    NSUInteger _sequenceNumber;
}

- (id)initWithDisplayController:(id<CTDDisplayController>)displayController
                     timeSource:(id<CTDTimeSource>)timeSource
{
    self = [super init];
    if (self) {
        _displayController = displayController;
        _timeSource = timeSource;
        _configurationScene = nil;
        _configurationActivity = nil;
        _connectionScene = nil;
        _connectionActivity = nil;
        _trialResults = nil;
        _displayTimer = nil;

        _participantId = 0;
        _preferredHand = CTDRightHand;
        _interfaceStyle = CTDModalInterfaceStyle;
        _sequenceNumber = 1;
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
    _configurationScene = [[CTDTaskConfigurationScene alloc] init];
    _configurationActivity = [[CTDTaskConfigurationActivity alloc] init];

    id<CTDTaskConfigurationSceneRenderer, CTDTaskConfigurationSceneInputSource>
        sceneBridge = [_displayController taskConfigurationSceneBridge];
    [sceneBridge setTaskConfigurationSceneInputRouter:_configurationScene];
    _configurationScene.sceneRenderer = sceneBridge;
    _configurationScene.configurationFormEditor = _configurationActivity;

    _configurationActivity.taskConfiguration = self;
    _configurationActivity.taskConfigurationForm = _configurationScene;
    _configurationActivity.notificationReceiver = self;

    [_configurationActivity resetForm];
}

// TODO: Handle completion of configuration, release scene, and startTrial


- (void)startTrial
{
    // TODO: Replace with data loaded from disk
    id<CTDTrialScript> trialScript = [CTDModel trialScriptWithDotPairs:@[
        step(CTDDotColor_Green, dot(1.0,0.34), dot(0.25,0.8)),
        step(CTDDotColor_Red, dot(0.15,0.01), dot(0.7,0.2))
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
    if ([notificationId isEqualToString:CTDTaskConfigurationCompletedNotification])
    {
        [self startTrial];
    }

    // TODO: remove sender check?
    else if ([notificationId isEqualToString:CTDTrialCompletedNotification] && sender == _connectionActivity)
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



#pragma mark CTDTaskConfiguration protocol


- (void)setParticipantId:(NSUInteger)participantId
{
    _participantId = participantId;
}

- (void)setPreferredHand:(CTDHand)preferredHand
{
    _preferredHand = preferredHand;
}

- (void)setInterfaceStyle:(CTDInterfaceStyle)interfaceStyle
{
    _interfaceStyle = interfaceStyle;
}

- (void)setSequenceNumber:(NSUInteger)sequenceNumber
{
    _sequenceNumber = sequenceNumber;
}

@end
