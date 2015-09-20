// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDConnectionActivity.h"
#import "CTDTaskConfiguration.h"
#import "CTDTaskConfigurationActivity.h"
#import "CTDTaskConfigurationScene.h"
#import "CTDTrialScriptCSVLoader.h"
#import "Ports/CTDConnectScene.h"
#import "Ports/CTDDisplayController.h"
#import "Ports/CTDTaskConfigurationSceneInputSource.h"
#import "Ports/CTDTaskConfigurationSceneRenderer.h"
#import "Ports/CTDTrialResultsFactory.h"

#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDModel.h"
#import "CTDModel/CTDTrialBlockResults.h"
#import "CTDModel/CTDTrialResults.h"
#import "CTDModel/CTDTrialScript.h"
#import "CTDUtility/CTDNotificationReceiver.h"
#import "CTDUtility/CTDPoint.h"
#import "CTDUtility/CTDRunLoopTimer.h"




// UI time intervals
static NSTimeInterval CTDTrialCompletionMessageDuration = 3.0;

// Application error domain
static NSString* CTDApplicationErrorDomain = @"CTDApplication";




// TODO: Split into helper class, so as to avoid having private methods?
@interface CTDApplication () <CTDNotificationReceiver,
                              CTDTaskConfiguration>
@end



@implementation CTDApplication
{
    id<CTDDisplayController> _displayController;
    id<CTDTrialResultsFactory> _trialResultsFactory;
    id<CTDTimeSource> _timeSource;

    NSArray* _dotSequences;
    CTDTaskConfigurationActivity* _configurationActivity;
    CTDTaskConfigurationScene* _configurationScene;
    CTDConnectionActivity* _connectionActivity;
    id<CTDConnectScene> _connectionScene;
    CTDRunLoopTimer* _displayTimer;

    // Task configuration
    NSUInteger _participantId;
    CTDHand _preferredHand;
    CTDInterfaceStyle _interfaceStyle;
    NSArray* _trialSequenceIds; // the order in which to present the sequences
    NSUInteger _trialIndex; // current position within above list

    id<CTDTrialBlockResults> _trialBlockResults;
    id<CTDTrialResults> _trialResults;
}

+ (NSURL*)documentsDirectoryOrError:(NSError *__autoreleasing *)error
{
    NSURL* documentsURL = [[NSFileManager defaultManager]
                           URLForDirectory:NSDocumentDirectory
                                  inDomain:NSUserDomainMask
                         appropriateForURL:nil
                                    create:YES
                                     error:error];
    return documentsURL;
}

- (id)initWithDisplayController:(id<CTDDisplayController>)displayController
            trialResultsFactory:(id<CTDTrialResultsFactory>)trialResultsFactory
                     timeSource:(id<CTDTimeSource>)timeSource
{
    self = [super init];
    if (self) {
        _displayController = displayController;
        _trialResultsFactory = trialResultsFactory;
        _timeSource = timeSource;

        _dotSequences = nil;
        _configurationActivity = nil;
        _configurationScene = nil;
        _connectionActivity = nil;
        _connectionScene = nil;
        _displayTimer = nil;

        _participantId = 0;
        _preferredHand = CTDRightHand;
        _interfaceStyle = CTDModalInterfaceStyle;
        _trialSequenceIds = nil;
        _trialIndex = 0;
        _trialBlockResults = nil;
        _trialResults = nil;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD


- (void)start
{
    NSString* scriptPath = [[NSBundle mainBundle]
                            pathForResource:@"TrialSequences" ofType:@"csv"];
    NSError* error = nil;
    _dotSequences = [CTDTrialScriptCSVLoader sequencesFromFileAtPath:scriptPath
                                                       sequenceCount:3
                                                      sequenceLength:20
                                                               error:&error];
    if (!_dotSequences && error)
    {
        [self displayScriptLoadError:error];
        return;
    }

    [self displayConfigurationScreen];
}

- (void)displayScriptLoadError:(NSError*)error
{
    NSString* message = [NSString stringWithFormat:@"Unable to load trial scripts: %@",
                         [error localizedDescription]];
    [_displayController displayFatalError:message];
}

- (void)displayResultsDestinationError:(NSError*)error
{
    NSString* message = @"Unable to locate Documents directory (for storing results)";
    NSString* fullText = [NSString stringWithFormat:@"%@: %@",
                          message,
                          [error localizedDescription]];
    [_displayController displayFatalError:fullText];
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

- (void)startTrialBlock
{
    _trialSequenceIds = @[ @1, @2 ]; // TODO: generate list from participant ID

    NSError* error = nil;
    _trialBlockResults =
        [_trialResultsFactory trialBlockResultsForParticipantId:_participantId
                                                  preferredHand:_preferredHand
                                                 interfaceStyle:_interfaceStyle
                                                          error:&error];
    if (!_trialBlockResults) { [self displayResultsDestinationError:error]; return; }

    _trialIndex = 0;
    [self startTrial];
}

- (void)startTrial
{
    NSUInteger sequenceId = [_trialSequenceIds[_trialIndex] unsignedIntegerValue];
    id<CTDTrialScript> trialScript = _dotSequences[sequenceId - 1];

    NSError* error = nil;
    _trialResults =
        [_trialResultsFactory trialResultsForParticipantId:_participantId
                                             preferredHand:_preferredHand
                                            interfaceStyle:_interfaceStyle
                                               trialNumber:_trialIndex + 1
                                                sequenceId:sequenceId
                                                     error:&error];

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
        [self startTrialBlock];
    }

    // TODO: remove sender check?
    else if ([notificationId isEqualToString:CTDTrialCompletedNotification] && sender == _connectionActivity)
    {
        [_trialResults finalizeResults];
        NSTimeInterval trialDuration = [_trialResults trialDuration];
        [_trialBlockResults setDuration:trialDuration
                         forTrialNumber:_trialIndex + 1
                             sequenceId:[_trialSequenceIds[_trialIndex] unsignedIntegerValue]];
        _trialResults = nil;

        int trialDurationSeconds = (int)round((double)trialDuration);
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

            strongSelf->_trialIndex += 1;
            if (strongSelf->_trialIndex < [strongSelf->_trialSequenceIds count])
            {
                [strongSelf startTrial];
            }
            else
            {
                [strongSelf->_trialBlockResults finalizeResults];
                strongSelf->_trialBlockResults = nil;
            }
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

//- (void)setSequenceNumber:(NSUInteger)sequenceNumber
//{
//    _sequenceNumber = sequenceNumber;
//}
//
@end
