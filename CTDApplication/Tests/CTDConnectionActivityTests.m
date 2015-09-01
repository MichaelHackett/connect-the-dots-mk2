// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDConnectionActivity.h"

#import "Ports/CTDTrialRenderer.h"
#import "CTDInteraction/Ports/CTDSelectionEditor.h"

#import "CTDStubTimeSource.h"
#import "CTDTrialRendererSpy.h"
#import "Ports/CTDColorCellRenderer.h"
#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDModel.h"
#import "CTDModel/CTDTrialResults.h"
#import "CTDModel/CTDTrialScript.h"
#import "CTDUtility/CTDNotificationReceiver.h"
#import "CTDUtility/CTDPoint.h"



// Test data
static double FIRST_STEP_START_TIME = 100000;
static double FIRST_STEP_END_TIME =   100008.5;



@interface CTDConnectionActivityTestCase : XCTestCase <CTDTrialResults,
                                                       CTDNotificationReceiver>

@property (strong, nonatomic) CTDConnectionActivity* subject;

// Collaborators
@property (strong, nonatomic) CTDTrialRendererSpy* trialRenderer;
@property (strong, nonatomic) CTDStubTimeSource* timeSource;

// Test fixture
@property (copy, nonatomic) NSArray* dotPairs;
@property (strong, nonatomic) id<CTDTrialScript> trialScript;

// Indirect outputs
@property (strong, nonatomic) NSMutableDictionary* stepDurations;

- (NSArray*)trialCompletionNotificationSenders;

@end



@implementation CTDConnectionActivityTestCase
{
    NSMutableArray* _trialCompletionNotificationSenders;
}

- (void)setUp
{
    [super setUp];
    _trialCompletionNotificationSenders = [[NSMutableArray alloc] init];
    self.dotPairs = @[
        [CTDModel dotPairWithColor:CTDDotColor_Red
                     startPosition:[CTDPoint x:49 y:250]
                       endPosition:[CTDPoint x:500 y:20]],
        [CTDModel dotPairWithColor:CTDDotColor_Blue
                     startPosition:[CTDPoint x:275 y:50]
                       endPosition:[CTDPoint x:25 y:460]],
        [CTDModel dotPairWithColor:CTDDotColor_Green
                     startPosition:[CTDPoint x:250 y:310]
                       endPosition:[CTDPoint x:415 y:315]]
    ];
    self.trialScript = [CTDModel trialScriptWithDotPairs:self.dotPairs];
    self.trialRenderer = [[CTDTrialRendererSpy alloc] init];
    self.timeSource = [[CTDStubTimeSource alloc] init];
    self.stepDurations = [[NSMutableDictionary alloc] init];
    self.subject = [[CTDConnectionActivity alloc]
                    initWithTrialScript:self.trialScript
                     trialResultsHolder:self
                          trialRenderer:self.trialRenderer
                     colorCellRenderers:nil // TODO
                             timeSource:self.timeSource
                    trialCompletionNotificationReceiver:self];

    self.timeSource.systemTime = FIRST_STEP_START_TIME;
    [self.subject beginTrial];
}

- (NSArray*)trialCompletionNotificationSenders
{
    return [_trialCompletionNotificationSenders copy];
}


#pragma mark CTDNotificationReceiver protocol

- (void)receiveNotification:(NSString*)notificationId
                 fromSender:(id)sender
                   withInfo:(__unused NSDictionary*)info
{
    if ([notificationId isEqualToString:CTDTrialCompletedNotification])
    {
        [_trialCompletionNotificationSenders addObject:sender];
    }
}


#pragma mark CTDTrialResults protocol

- (void)setDuration:(double)stepDuration forStepNumber:(NSUInteger)stepNumber
{
    self.stepDurations[@(stepNumber)] = @(stepDuration);
}

- (NSTimeInterval)trialDuration { return 0.0; }  // not used in tests

@end




@interface CTDConnectionActivityWhenFirstBegan : CTDConnectionActivityTestCase
@end
@implementation CTDConnectionActivityWhenFirstBegan

- (void)testThatExactlyOneDotIsVisible
{
    assertThat(self.trialRenderer.dotRenderings, hasCountOf(1));
}

- (void)testThatFirstDotIsRenderedInCorrectPosition
{
    assertThat([self.trialRenderer.dotRenderings[0] dotCenterPosition],
               is(equalTo([self.dotPairs[0] startPosition])));
}

- (void)testThatFirstDotIsRenderedWithCorrectColor
{
    assertThat([self.trialRenderer.dotRenderings[0] dotColor],
               is(equalTo(CTDPaletteColor_DotType1)));
}

- (void)testThatStartingDotIsNotRenderedAsActivated
{
    assertThatBool([self.trialRenderer.dotRenderings[0] hasSelectionIndicator],
                   is(equalToBool(NO)));
}

- (void)testThatItAddsNoVisibleConnections
{
    assertThat(self.trialRenderer.connectionRenderings, hasCountOf(0));
}

@end




@interface CTDConnectionActivityTrialStepEditorWhenCorrectColorIsSelected
    : CTDConnectionActivityTestCase
@end

@implementation CTDConnectionActivityTrialStepEditorWhenCorrectColorIsSelected

- (void)setUp
{
    [super setUp];
    [self.subject selectColor:[(CTDDotPair*)self.dotPairs[0] color]];
}

- (void)testThatConnectionIsAllowed
{
    assertThatBool([[self.subject editorForCurrentStep] isConnectionAllowed],
                   is(equalToBool(YES)));
}

- (void)testThatReturnedConnectionEditorIsNotNil
{
    assertThat([[self.subject editorForCurrentStep] editorForNewConnection], is(notNilValue()));
}

@end




@interface CTDConnectionActivityTrialStepEditorWhenCorrectColorIsNotSelected
    : CTDConnectionActivityTestCase
@end

@implementation CTDConnectionActivityTrialStepEditorWhenCorrectColorIsNotSelected

- (void)setUp
{
    [super setUp];
    [self.subject selectColor:[(CTDDotPair*)self.dotPairs[0] color] + 1];
}

- (void)testThatConnectionIsNotAllowed
{
    assertThatBool([[self.subject editorForCurrentStep] isConnectionAllowed],
                   is(equalToBool(NO)));
}

- (void)testThatReturnedConnectionEditorIsNil
{
    assertThat([[self.subject editorForCurrentStep] editorForNewConnection], is(nilValue()));
}

@end




@interface CTDConnectionActivityWhenCorrectColorIsNotSelectedAndConnectionAttempted
    : CTDConnectionActivityTestCase
@end

@implementation CTDConnectionActivityWhenCorrectColorIsNotSelectedAndConnectionAttempted
{
    id<CTDTrialStepConnectionEditor> _newConnectionEditor;
}

- (void)setUp
{
    [super setUp];
    _newConnectionEditor = [[self.subject editorForCurrentStep] editorForNewConnection];
}

- (void)testThatStartingDotIsNotRenderedAsActivated
{
    assertThatBool([self.trialRenderer.dotRenderings[0] hasSelectionIndicator],
                   is(equalToBool(NO)));
}

- (void)testThatSecondDotIsNotMadeVisible
{
    assertThat(self.trialRenderer.dotRenderings, hasCountOf(1));
}

- (void)testThatItAddsNoVisibleConnections
{
    assertThat(self.trialRenderer.connectionRenderings, hasCountOf(0));
}

@end




@interface CTDConnectionActivityTrialStepEditorWhenColorIsSelectedThroughEditor
    : CTDConnectionActivityTestCase
@end

@implementation CTDConnectionActivityTrialStepEditorWhenColorIsSelectedThroughEditor

- (void)setUp
{
    [super setUp];
    id<CTDSelectionEditor> selectionEditor = [self.subject editorForColorSelection];
    id dotCellId = @([(CTDDotPair*)self.dotPairs[0] color] - CTDDotColor_Red + CTDColorCellIdMin);
    [selectionEditor selectElementWithId:dotCellId];
}

- (void)testThatConnectionIsAllowed
{
    assertThatBool([[self.subject editorForCurrentStep] isConnectionAllowed],
                   is(equalToBool(YES)));
}

- (void)testThatReturnedConnectionEditorIsNotNil
{
    assertThat([[self.subject editorForCurrentStep] editorForNewConnection], is(notNilValue()));
}

@end




@interface CTDConnectionActivityWithActiveConnection : CTDConnectionActivityTestCase

@property (strong, nonatomic) id<CTDTrialStepConnectionEditor> connectionEditor;

@end

@implementation CTDConnectionActivityWithActiveConnection

- (void)setUp
{
    [super setUp];
    [self.subject selectColor:[(CTDDotPair*)self.dotPairs[0] color]];
    self.connectionEditor = [[self.subject editorForCurrentStep] editorForNewConnection];
}

@end




@interface CTDConnectionActivityAfterConnectionAnchoredToFirstDot
    : CTDConnectionActivityWithActiveConnection
@end

@implementation CTDConnectionActivityAfterConnectionAnchoredToFirstDot

- (void)testThatStartingDotIsRenderedAsActivated
{
    assertThatBool([self.trialRenderer.dotRenderings[0] hasSelectionIndicator],
                   is(equalToBool(YES)));
}

- (void)testThatSecondDotIsMadeVisible
{
    assertThat(self.trialRenderer.dotRenderings, hasCountOf(2));
}

- (void)testThatSecondDotIsInCorrectPosition
{
    assertThat([self.trialRenderer.dotRenderings[1] dotCenterPosition],
               is(equalTo([self.dotPairs[0] endPosition])));
}

- (void)testThatSecondDotIsRenderedInSameColor
{
    assertThat([self.trialRenderer.dotRenderings[1] dotColor],
               is(equalTo(CTDPaletteColor_DotType1)));
}

- (void)testThatSecondDotIsNotRenderedAsActivated
{
    assertThatBool([self.trialRenderer.dotRenderings[1] hasSelectionIndicator],
                   is(equalToBool(NO)));
}

- (void)testThatConnectionIsRendered
{
    assertThat(self.trialRenderer.connectionRenderings, hasCountOf(1));
}

- (void)testThatOneEndOfConnectionIsRenderedFromFirstDot
{
    CTDFakeConnectionRendering* connection = self.trialRenderer.connectionRenderings[0];
    assertThat(connection.firstEndpointPosition,
               is(equalTo([self.trialRenderer.dotRenderings[0] dotConnectionPoint])));
}

- (void)testThatFreeEndOfConnectionIsRenderedToTheSamePointAsTheAnchoredEnd
{
    CTDFakeConnectionRendering* connection = self.trialRenderer.connectionRenderings[0];
    assertThat(connection.secondEndpointPosition,
               is(equalTo([self.trialRenderer.dotRenderings[0] dotConnectionPoint])));
}

@end




@interface CTDConnectionActivityWhenFreeEndOfConnectionChanges
    : CTDConnectionActivityWithActiveConnection
@end

@implementation CTDConnectionActivityWhenFreeEndOfConnectionChanges
{
    CTDPoint* _newFreeEndPosition;
}

- (void)setUp
{
    [super setUp];
    _newFreeEndPosition = [CTDPoint x:50 y:290];
    [self.connectionEditor setFreeEndPosition:_newFreeEndPosition];
}

- (void)testThatStartingDotRemainsRenderedAsActivated
{
    assertThatBool([self.trialRenderer.dotRenderings[0] hasSelectionIndicator],
                   is(equalToBool(YES)));
}

- (void)testThatTheEndingDotRemainsRenderedAsUnactivated
{
    assertThatBool([self.trialRenderer.dotRenderings[1] hasSelectionIndicator],
                   is(equalToBool(NO)));
}

- (void)testThatConnectionRemainsRenderedAnchoredFromFirstDot
{
    CTDFakeConnectionRendering* connection = self.trialRenderer.connectionRenderings[0];
    assertThat(connection.firstEndpointPosition,
               is(equalTo([self.trialRenderer.dotRenderings[0] dotConnectionPoint])));
}

- (void)testThatFreeEndOfConnectionIsRendereredToTheNewFreeEndPosition
{
    CTDFakeConnectionRendering* connection = self.trialRenderer.connectionRenderings[0];
    assertThat(connection.secondEndpointPosition, is(equalTo(_newFreeEndPosition)));
}

@end




@interface CTDConnectionActivityAfterCompletingConnection
    : CTDConnectionActivityWithActiveConnection
@end

@implementation CTDConnectionActivityAfterCompletingConnection

- (void)setUp
{
    [super setUp];
    [self.connectionEditor establishConnection];
}

- (void)testThatStartingDotRemainsRenderedAsActivated
{
    assertThatBool([self.trialRenderer.dotRenderings[0] hasSelectionIndicator],
                   is(equalToBool(YES)));
}

- (void)testThatEndingDotIsRenderedAsActivated
{
    assertThatBool([self.trialRenderer.dotRenderings[1] hasSelectionIndicator],
                   is(equalToBool(YES)));
}

- (void)testThatConnectionRemainsRenderedAnchoredFromFirstDot
{
    CTDFakeConnectionRendering* connection = self.trialRenderer.connectionRenderings[0];
    assertThat(connection.firstEndpointPosition,
               is(equalTo([self.trialRenderer.dotRenderings[0] dotConnectionPoint])));
}

- (void)testThatFreeEndOfConnectionIsRendereredConnectedToSecondDot
{
    CTDFakeConnectionRendering* connection = self.trialRenderer.connectionRenderings[0];
    assertThat(connection.secondEndpointPosition,
               is(equalTo([self.trialRenderer.dotRenderings[1] dotConnectionPoint])));
}

@end




@interface CTDConnectionActivityAfterCommittingConnection : CTDConnectionActivityWithActiveConnection
@property (strong, nonatomic) id<CTDTrialStepEditor> previousStepEditor;
@property (strong, nonatomic) CTDFakeDotRendering* previousStepFirstDotRendering;
@property (strong, nonatomic) CTDFakeDotRendering* previousStepSecondDotRendering;
@property (strong, nonatomic) CTDFakeConnectionRendering* previousStepConnectionRendering;
@end

@implementation CTDConnectionActivityAfterCommittingConnection

- (void)setUp
{
    [super setUp];
    [self.connectionEditor establishConnection];

    // Save refs to current renderings so we can verify that they have been
    // hidden after the step has been completed.
    self.previousStepEditor = [self.subject editorForCurrentStep];
    self.previousStepFirstDotRendering = self.trialRenderer.dotRenderings[0];
    self.previousStepSecondDotRendering = self.trialRenderer.dotRenderings[1];
    self.previousStepConnectionRendering = self.trialRenderer.connectionRenderings[0];

    self.timeSource.systemTime = FIRST_STEP_END_TIME;
    [self.connectionEditor commitConnectionState];
}

- (void)testThatStartingDotFromPreviousStepHasBeenHidden
{
    assertThatBool([self.previousStepFirstDotRendering isVisible], is(equalToBool(NO)));
}

- (void)testThatEndingDotFromPreviousStepHasBeenHidden
{
    assertThatBool([self.previousStepSecondDotRendering isVisible], is(equalToBool(NO)));
}

- (void)testThatConnectionFromPreviousStepHasBeenHidden
{
    assertThatBool([self.previousStepConnectionRendering isVisible], is(equalToBool(NO)));
}

- (void)testThatExactlyOneDotIsVisible
{
    assertThat(self.trialRenderer.dotRenderings, hasCountOf(1));
}

- (void)testThatFirstDotIsRenderedInStartingPositionFromFollowingStep
{
    assertThat([self.trialRenderer.dotRenderings[0] dotCenterPosition],
               is(equalTo([self.dotPairs[1] startPosition])));
}

- (void)testThatFirstDotIsRenderedWithColorForFollowingStep
{
    assertThat([self.trialRenderer.dotRenderings[0] dotColor],
               is(equalTo(CTDPaletteColor_DotType3)));
}

- (void)testThatStartingDotIsNotRenderedAsActivated
{
    assertThatBool([self.trialRenderer.dotRenderings[0] hasSelectionIndicator],
                   is(equalToBool(NO)));
}

- (void)testThatNoConnectionIsVisible
{
    assertThat(self.trialRenderer.connectionRenderings, hasCountOf(0));
}

- (void)testThatTheTrialEditorHasNewStepEditor
{
    assertThat([self.subject editorForCurrentStep],
               is(allOf(notNilValue(), isNot(sameInstance(self.previousStepEditor)), nil)));
}

- (void)testThatTrialStepDurationHasBeenRecorded
{
    assertThat(self.stepDurations, hasCountOf(1));
    assertThatDouble([self.stepDurations[@(1)] doubleValue], is(closeTo(8.5, 0.01)));
}

@end




@interface CTDConnectionActivityAfterBreakingEstablishedConnection
    : CTDConnectionActivityWithActiveConnection
@end

@implementation CTDConnectionActivityAfterBreakingEstablishedConnection
{
    CTDPoint* _newFreeEndPosition;
}

- (void)setUp
{
    [super setUp];
    [self.connectionEditor establishConnection];
    _newFreeEndPosition = [CTDPoint x:4 y:36];
    [self.connectionEditor setFreeEndPosition:_newFreeEndPosition];
}

- (void)testThatStartingDotRemainsRenderedAsActivated
{
    assertThatBool([self.trialRenderer.dotRenderings[0] hasSelectionIndicator],
                   is(equalToBool(YES)));
}

- (void)testThatEndingDotIsRenderedAsNotActivated
{
    assertThatBool([self.trialRenderer.dotRenderings[1] hasSelectionIndicator],
                   is(equalToBool(NO)));
}

- (void)testThatConnectionRemainsRenderedAnchoredFromFirstDot
{
    CTDFakeConnectionRendering* connection = self.trialRenderer.connectionRenderings[0];
    assertThat(connection.firstEndpointPosition,
               is(equalTo([self.trialRenderer.dotRenderings[0] dotConnectionPoint])));
}

- (void)testThatFreeEndOfConnectionIsRendereredToTheNewFreeEndPosition
{
    CTDFakeConnectionRendering* connection = self.trialRenderer.connectionRenderings[0];
    assertThat(connection.secondEndpointPosition, is(equalTo(_newFreeEndPosition)));
}

@end




@interface CTDConnectionActivityAfterCancellingConnection
    : CTDConnectionActivityWithActiveConnection
@end

@implementation CTDConnectionActivityAfterCancellingConnection

- (void)setUp
{
    [super setUp];
    [self.connectionEditor cancelConnection];
}

- (void)testThatStartingDotIsNotRenderedAsActivated
{
    assertThatBool([self.trialRenderer.dotRenderings[0] hasSelectionIndicator],
                   is(equalToBool(NO)));
}

- (void)testThatSecondDotIsHidden
{
    assertThat(self.trialRenderer.dotRenderings, hasCountOf(1));
}

- (void)testThatConnectionIsNoLongerRendered
{
    assertThat(self.trialRenderer.connectionRenderings, hasCountOf(0));
}

@end




@interface CTDConnectionActivityStartingSecondConnectionAfterFirstCancelled
    : CTDConnectionActivityTestCase
@end

@implementation CTDConnectionActivityStartingSecondConnectionAfterFirstCancelled
{
    id<CTDTrialStepConnectionEditor> _connectionEditor;
}

- (void)setUp
{
    [super setUp];
    id<CTDTrialStepEditor> trialStepEditor = [self.subject editorForCurrentStep];
    // Start and cancel one connection.
    [self.subject selectColor:[(CTDDotPair*)self.dotPairs[0] color]];
    [[trialStepEditor editorForNewConnection] cancelConnection];
    // Then start a second.
    _connectionEditor = [trialStepEditor editorForNewConnection];
}

- (void)testThatStartingDotIsRenderedAsActivated
{
    assertThatBool([self.trialRenderer.dotRenderings[0] hasSelectionIndicator],
                   is(equalToBool(YES)));
}

- (void)testThatSecondDotIsMadeVisible
{
    assertThat(self.trialRenderer.dotRenderings, hasCountOf(2));
}

- (void)testThatConnectionIsRendered
{
    assertThat(self.trialRenderer.connectionRenderings, hasCountOf(1));
}

- (void)testThatConnectionIsAnchoredAtFirstDot
{
    CTDFakeConnectionRendering* connection = self.trialRenderer.connectionRenderings[0];
    assertThat(connection.firstEndpointPosition,
               is(equalTo([self.trialRenderer.dotRenderings[0] dotConnectionPoint])));
}

- (void)testThatFreeEndOfConnectionIsTheSameAsTheAnchoredEnd
{
    CTDFakeConnectionRendering* connection = self.trialRenderer.connectionRenderings[0];
    assertThat(connection.secondEndpointPosition,
               is(equalTo([self.trialRenderer.dotRenderings[0] dotConnectionPoint])));
}

- (void)testThatReturnedConnectionEditorIsNotNil
{
    assertThat(_connectionEditor, is(notNilValue()));
}

@end




@interface CTDConnectionActivityAfterCompletingFinalStep : CTDConnectionActivityTestCase
@end

@implementation CTDConnectionActivityAfterCompletingFinalStep
{
    NSDictionary* _expectedStepDurations;
}

- (void)setUp
{
    [super setUp];
    NSUInteger stepCount = [self.dotPairs count];
    double nextStepDuration = 3.75;
    NSMutableDictionary* expectedStepDurations = [[NSMutableDictionary alloc] init];
    for (NSUInteger stepIndex = 0; stepIndex < stepCount; stepIndex += 1)
    {
        expectedStepDurations[@(stepIndex+1)] = @(nextStepDuration);
        self.timeSource.systemTime += nextStepDuration;
        [self.subject advanceToNextStep];

        nextStepDuration += 1.25; // make each step duration different
    }

    _expectedStepDurations = [expectedStepDurations copy];
}

//- (void)testThatTrialIsMarkedCompleted
//{
//}

- (void)testThatListenersAreNotifiedThatTheTrialIsComplete
{
    assertThat(self.trialCompletionNotificationSenders, hasItem(self.subject));
}

- (void)testThatEachStepHasTheCorrectDuration
{
    assertThat(self.stepDurations, is(equalTo(_expectedStepDurations)));
}

@end
