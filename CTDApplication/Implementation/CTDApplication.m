// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDConnectionActivity.h"
#import "CTDCSVFileTrialResults.h"
#import "CTDTaskConfiguration.h"
#import "CTDTaskConfigurationActivity.h"
#import "CTDTaskConfigurationScene.h"
#import "CTDTrialScriptCSVLoader.h"
#import "Ports/CTDConnectScene.h"
#import "Ports/CTDDisplayController.h"
#import "Ports/CTDTaskConfigurationSceneInputSource.h"
#import "Ports/CTDTaskConfigurationSceneRenderer.h"

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
    NSArray* _dotSequences;
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
                     timeSource:(id<CTDTimeSource>)timeSource
{
    self = [super init];
    if (self) {
        _dotSequences = nil;
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
    id<CTDTrialScript> trialScript = _dotSequences[0];
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
        NSError* error = nil;
        NSURL* documentsURL = [[self class] documentsDirectoryOrError:&error];
        if (!documentsURL)
        {
            NSString* message = @"Unable to locate Documents directory (for storing results)";
            NSString* fullText = [NSString stringWithFormat:@"%@: %@",
                                  message,
                                  [error localizedDescription]];
            [_displayController displayFatalError:fullText];
        }
        else
        {
            //TODO: get actual results from config
            NSUInteger participantId = 9;
            CTDHand preferredHand = CTDLeftHand;
            CTDInterfaceStyle interfaceStyle = CTDModalInterfaceStyle;

            NSString* blockResultsFilename =
                [NSString stringWithFormat:@"P%02lu%c.csv",
                 (unsigned long)participantId,
                 interfaceStyle == CTDModalInterfaceStyle ? 'M' : 'Q'];
            NSURL* blockResultsURL =
                [documentsURL URLByAppendingPathComponent:blockResultsFilename];
            // TODO: Verify that no file exists at this path
            NSOutputStream* blockResultsStream = [[NSOutputStream alloc]
                                                  initWithURL:blockResultsURL
                                                       append:NO];
//            blockResultsStream.delegate = self;
//            [blockResultsStream scheduleInRunLoop:self.runLoop forMode:self.runLoopMode];
            [blockResultsStream scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                          forMode:NSRunLoopCommonModes];
            [blockResultsStream open];

            id<CTDTrialBlockResults> blockResults =
                [[CTDCSVTrialBlockWriter alloc]
                 initWithParticipantId:participantId
                         preferredHand:preferredHand
                        interfaceStyle:interfaceStyle
                          outputStream:blockResultsStream];
            [blockResults setDuration:23.45 forTrialNumber:3 sequenceId:17];

            // TODO: flush output before closing
            [blockResultsStream close];
//            [blockResultsStream removeFromRunLoop:self.runLoop forMode:self.runLoopMode];
            [blockResultsStream removeFromRunLoop:[NSRunLoop mainRunLoop]
                                          forMode:NSRunLoopCommonModes];
            blockResultsStream.delegate = nil;

            [self startTrial];
        }
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
