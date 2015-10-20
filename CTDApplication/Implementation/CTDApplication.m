// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDConnectionActivity.h"
#import "CTDTaskConfiguration.h"
#import "CTDTaskConfigurationActivity.h"
#import "CTDTaskConfigurationScene.h"
#import "CTDTrialMenuSceneInputRouter.h"
#import "CTDTrialScriptCSVLoader.h"
#import "Ports/CTDAppStateRecorder.h"
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
static NSTimeInterval const CTDTrialCompletionMessageDuration = 3.0;

// Application error domain
static NSString* const CTDApplicationErrorDomain = @"CTDApplication";

// Number of practice runs
static NSUInteger const practiceTrialCount = 2;

/// Convenience function for making trial index checks more readable inline.
static BOOL isPracticeTrialIndex(NSUInteger trialIndex)
{
    return trialIndex < practiceTrialCount;
}




/// Convert a NSTimeInterval into a string showing minutes and seconds (rounded to nearest).
static NSString* formatTime(NSTimeInterval time)
{
    int timeInSeconds = (int)round((double)time);
    return [NSString stringWithFormat:@"%02d:%02d",
                     timeInSeconds / 60,
                     timeInSeconds % 60];
}




// TODO: Split into helper class, so as to avoid having private methods?
@interface CTDApplication () <CTDNotificationReceiver,
                              CTDTrialMenuSceneInputRouter, // TEMP
                              CTDTaskConfiguration>
@end



@implementation CTDApplication
{
    id<CTDDisplayController> _displayController;
    id<CTDTrialResultsFactory> _trialResultsFactory;
    id<CTDAppStateRecorder> _appStateRecorder;
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
               appStateRecorder:(id<CTDAppStateRecorder>)appStateRecorder
                     timeSource:(id<CTDTimeSource>)timeSource
                   randomalizer:(id<CTDRandomalizer>)randomalizer
{
    self = [super init];
    if (self) {
        _displayController = displayController;
        _trialResultsFactory = trialResultsFactory;
        _appStateRecorder = appStateRecorder;
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


// TODO: Move private method to new host
- (void)CTDApplication_prepareTrialBlockResults
{
    NSError* error = nil;
    _trialBlockResults =
        [_trialResultsFactory trialBlockResultsForParticipantId:_participantId
                                                  preferredHand:_preferredHand
                                                 interfaceStyle:_interfaceStyle
                                                          error:&error];
    if (!_trialBlockResults) { [self displayResultsDestinationError:error]; }
}

- (void)start
{
    NSString* scriptPath = [[NSBundle mainBundle]
                            pathForResource:@"TrialSequences" ofType:@"csv"];
    NSError* error = nil;
    _dotSequences = [CTDTrialScriptCSVLoader sequencesFromFileAtPath:scriptPath
                                                       sequenceCount:12
                                                      sequenceLength:20
                                                               error:&error];
    if (!_dotSequences && error)
    {
        [self displayScriptLoadError:error];
        return;
    }

    id<CTDApplicationState> savedState = [_appStateRecorder savedApplicationState];
    if ([[savedState participantId] unsignedIntegerValue] > 0)
    {
        _participantId = [[savedState participantId] unsignedIntegerValue];
        _preferredHand = [[savedState preferredHand] unsignedIntegerValue];
        _interfaceStyle = [[savedState interfaceStyle] unsignedIntegerValue];
        _sequenceOrder = [[savedState sequenceOrder] copy];
        _trialIndex = [[savedState trialIndex] unsignedIntegerValue];

        [self CTDApplication_prepareTrialBlockResults];
        if (!_trialBlockResults) { return; }

        // Rebuild the trial results up to the point where the block was interrupted.
        [[savedState trialDurations] enumerateObjectsUsingBlock:
            ^(NSNumber* trialDuration, NSUInteger index, __unused BOOL* stop)
            {
                NSUInteger sequenceId =
                    [self->_sequenceOrder[index + practiceTrialCount]
                     unsignedIntegerValue];

                [self->_trialBlockResults setDuration:[trialDuration doubleValue]
                                       forTrialNumber:index + 1
                                           sequenceId:sequenceId];
            }
        ];

        [self startTrial];
    }
    else
    {
        [self displayConfigurationScreen];
    }
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
    NSAssert(sequenceLength < (NSUInteger)NSIntegerMax,
             @"Sequence count too large (>%lu)", NSIntegerMax);
    if (_participantId < 1 || sequenceLength < 1) { return @[]; }

    // Keep the practice sequences the same for all; only randomize the rest.
    NSArray* practiceSequenceIndices = (practiceTrialCount > 0)
        ? practiceSequenceIndices = [NSArray ctd_arrayOfIntegersFrom:0
                                             to:(NSInteger)practiceTrialCount - 1]
        : @[];

    NSArray* mainSequenceIndices =
        [NSArray ctd_arrayOfIntegersFrom:practiceTrialCount
                                      to:(NSInteger)sequenceLength - 1];

    // Using a pseudo-random seed based on the participant ID, randomly reorder
    // a list of the sequence indices. (Note: Multiplying the participant ID by
    // a largish prime number, in order to spread out the seed values, seems to
    // improve the distribution of starting indices, but it's not based on any
    // principles I'm aware of, except that a similar technique is recommended
    // when generating hash values.)
    unsigned long seed = _participantId * 2789; // arbitrary largish prime (that won't overflow)
    return [practiceSequenceIndices arrayByAddingObjectsFromArray:
               [_randomalizer randomizeList:mainSequenceIndices seed:seed]];
}

- (void)startTrialBlock
{
    _sequenceOrder = [self sequenceOrder];

    [self CTDApplication_prepareTrialBlockResults];
    if (!_trialBlockResults) { return; }

    _trialIndex = 0;
    [self startTrial];
}

- (void)startTrial
{
    NSAssert(_trialBlockResults,
             @"failed to create trial block results holder before starting trial");

    [_appStateRecorder updateSavedApplicationStateWithBuilder:^(id<CTDMutableApplicationState> state) {
        [state setParticipantId:@(self->_participantId)];
        [state setPreferredHand:@(self->_preferredHand)];
        [state setInterfaceStyle:@(self->_interfaceStyle)];
        [state setSequenceOrder:self->_sequenceOrder];
        [state setTrialIndex:@(self->_trialIndex)];
        [state setTrialDurations:[self->_trialBlockResults trialDurations]];
    }];

    NSUInteger sequenceIndex = [_sequenceOrder[_trialIndex] unsignedIntegerValue];
    id<CTDTrialScript> trialScript = _dotSequences[sequenceIndex];

    // The trial number for the recorded data and UI; practice rounds are numbered under 0.
    NSInteger trialNumber = (NSInteger)_trialIndex + 1 - (NSInteger)practiceTrialCount;

    if (isPracticeTrialIndex(_trialIndex))
    {
        _trialResults = [CTDModel trialResultsHolder]; // use non-recording results holder
    }
    else
    {
        NSAssert(trialNumber >= 1, @"trial number is less than 1");
        NSError* error = nil;
        _trialResults =
            [_trialResultsFactory trialResultsForParticipantId:_participantId
                                                 preferredHand:_preferredHand
                                                interfaceStyle:_interfaceStyle
                                                   trialNumber:(NSUInteger)trialNumber
                                                    sequenceId:sequenceIndex + 1
                                                         error:&error];
    }

    // Configure UI for connect-the-dots task
    BOOL quasimodalButtons = (_interfaceStyle == CTDQuasimodalInterfaceStyle);
    BOOL colorBarOnRight = quasimodalButtons ? (_preferredHand == CTDLeftHand)
                                             : (_preferredHand == CTDRightHand);
    _connectionScene =
        [_displayController connectionSceneWithColorBarOnRight:colorBarOnRight
                                             quasimodalButtons:quasimodalButtons];

    _connectionActivity = [[CTDConnectionActivity alloc]
                           initWithTrialScript:trialScript
                           trialResultsHolder:_trialResults
                           trialRenderer:_connectionScene.trialRenderer
                           colorCellRenderers:[_connectionScene colorCellRendererMap]
                           timeSource:_timeSource
                           trialCompletionNotificationReceiver:self];

    [_connectionScene displayPreTrialMenuForTrialNumber:trialNumber
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
    [_connectionScene confirmExitWithResponseHandler:^(BOOL confirmed)
    {
        if (confirmed) { [self displayConfigurationScreen]; }
    }];
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
        NSString* bestTimeString = 0;
        // Don't record practice trial results.
        if (!isPracticeTrialIndex(_trialIndex))
        {
            NSUInteger trialNumber = _trialIndex + 1 - practiceTrialCount;
            [_trialBlockResults setDuration:trialDuration
                             forTrialNumber:trialNumber
                                 sequenceId:[_sequenceOrder[_trialIndex] unsignedIntegerValue]];
            bestTimeString = formatTime([_trialBlockResults shortestTrialTime]);
        }
        _trialResults = nil;
        [_connectionScene displayTrialCompletionMessageWithTimeString:formatTime(trialDuration)
                                                       bestTimeString:bestTimeString];

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
                id<CTDTrialBlockResults> trialBlockResults = strongSelf->_trialBlockResults;
                strongSelf->_trialBlockResults = nil;
                [trialBlockResults finalizeResults];
                NSUInteger trialCount = [trialBlockResults trialCount];
                NSString* totalTime = formatTime([trialBlockResults totalDuration]);
                [strongSelf->_connectionScene
                    displayTrialBlockCompletionMessageWithTrialCount:trialCount
                                                     totalTimeString:totalTime
                                              acknowledgementHandler:^
                {
                    ctd_strongify(weakSelf, strongSelf2);

                    // Clearing saved participant ID will send app to config screen on launch.
                    [strongSelf2->_appStateRecorder
                        updateSavedApplicationStateWithBuilder:^(id<CTDMutableApplicationState> state) {
                        [state setParticipantId:nil];
                    }];

                    [strongSelf2 displayConfigurationScreen];
                }];
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
