// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDConnectionActivity.h"
#import "CTDTaskConfiguration.h"
#import "CTDTaskConfigurationActivity.h"
#import "CTDTaskConfigurationScene.h"
#import "CTDTrialMenuSceneInputRouter.h"
#import "CTDTrialScriptCSVLoader.h"
#import "Ports/CTDConnectScene.h"
#import "Ports/CTDDisplayController.h"
#import "Ports/CTDRandomalizer.h"
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
#import "CTDUtility/NSArray+CTDAdditions.h"




// UI time intervals
static NSTimeInterval CTDTrialCompletionMessageDuration = 3.0;

// Application error domain
static NSString* CTDApplicationErrorDomain = @"CTDApplication";




// TODO: Split into helper class, so as to avoid having private methods?
@interface CTDApplication () <CTDNotificationReceiver,
                              CTDTrialMenuSceneInputRouter, // TEMP
                              CTDTaskConfiguration>
@end



@implementation CTDApplication
{
    id<CTDDisplayController> _displayController;
    id<CTDTrialResultsFactory> _trialResultsFactory;
    id<CTDTimeSource> _timeSource;
    id<CTDRandomalizer> _randomalizer;

    NSArray* _dotSequences;   // of CTDTrialScripts
    CTDTaskConfigurationActivity* _configurationActivity;
    CTDTaskConfigurationScene* _configurationScene;
    CTDConnectionActivity* _connectionActivity;
    id<CTDConnectScene> _connectionScene;
    CTDRunLoopTimer* _displayTimer;

    // Task configuration
    NSUInteger _participantId;
    CTDHand _preferredHand;
    CTDInterfaceStyle _interfaceStyle;
    NSArray* _sequenceOrder; // of NSNumber -- the order in which to present the sequences
    NSUInteger _trialIndex; // current position within above list

    id<CTDTrialBlockResults> _trialBlockResults;
    id<CTDTrialResults> _trialResults;
}

- (id)initWithDisplayController:(id<CTDDisplayController>)displayController
            trialResultsFactory:(id<CTDTrialResultsFactory>)trialResultsFactory
                     timeSource:(id<CTDTimeSource>)timeSource
                   randomalizer:(id<CTDRandomalizer>)randomalizer
{
    self = [super init];
    if (self) {
        _displayController = displayController;
        _trialResultsFactory = trialResultsFactory;
        _timeSource = timeSource;
        _randomalizer = randomalizer;

        _dotSequences = nil;
        _configurationActivity = nil;
        _configurationScene = nil;
        _connectionActivity = nil;
        _connectionScene = nil;
        _displayTimer = nil;

        _participantId = 0;
        _preferredHand = CTDRightHand;
        _interfaceStyle = CTDModalInterfaceStyle;
        _sequenceOrder = nil;
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

// TODO: Move method
//- (NSArray*)sequenceOrderForParticipantWithId:(NSUInteger)participantId
//                                       length:(NSUInteger)sequenceLength
- (NSArray*)sequenceOrder
{
    NSUInteger sequenceLength = [_dotSequences count];
    if (_participantId < 1 || sequenceLength < 1) { return @[]; }

    // Using a pseudo-random seed based on the participant ID, randomly reorder
    // a list of the sequence indices.
    unsigned long seed = _participantId * 2789; // arbitrary largish prime (that won't overflow)
    NSAssert(sequenceLength < (NSUInteger)NSIntegerMax,
             @"Sequence count too large (>%lu)", NSIntegerMax);
    NSArray* sequenceIndices =
        [NSArray ctd_arrayOfIntegersFrom:0 to:(NSInteger)sequenceLength - 1];
    return [_randomalizer randomizeList:sequenceIndices seed:seed];

    // (Note: Multiplying the participant ID by a largish prime number, in
    // order to spread out the seed values, seemed to improve the distribution
    // of starting indices, but it's not based on any principles I'm aware of,
    // except that a similar technique is recommended when generating hash values.)
}

- (void)startTrialBlock
{
    _sequenceOrder = [self sequenceOrder];

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
    NSUInteger sequenceIndex = [_sequenceOrder[_trialIndex] unsignedIntegerValue];
    id<CTDTrialScript> trialScript = _dotSequences[sequenceIndex];

    NSError* error = nil;
    _trialResults =
        [_trialResultsFactory trialResultsForParticipantId:_participantId
                                             preferredHand:_preferredHand
                                            interfaceStyle:_interfaceStyle
                                               trialNumber:_trialIndex + 1
                                                sequenceId:sequenceIndex + 1
                                                     error:&error];

    _connectionScene = [_displayController connectScene];

    _connectionActivity = [[CTDConnectionActivity alloc]
                           initWithTrialScript:trialScript
                           trialResultsHolder:_trialResults
                           trialRenderer:_connectionScene.trialRenderer
                           colorCellRenderers:[_connectionScene colorCellRendererMap]
                           timeSource:_timeSource
                           trialCompletionNotificationReceiver:self];

    [_connectionScene displayPreTrialMenuWithMessage:@"Hang on!"
                                         inputRouter:self];
}

- (void)beginButtonPressed
{
    [_connectionScene hidePreTrialMenu];
    [_connectionActivity beginTrial];
    [_connectionScene setTrialEditor:_connectionActivity];
}

- (void)exitButtonPressed
{
    // TODO
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
                             sequenceId:[_sequenceOrder[_trialIndex] unsignedIntegerValue]];
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
            if (strongSelf->_trialIndex < [strongSelf->_sequenceOrder count])
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
