// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDConnectionActivity.h"

#import "Ports/CTDTrialRenderer.h"

#import "CTDTrialRendererSpy.h"
#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDModel.h"
#import "CTDModel/CTDTrial.h"
#import "CTDUtility/CTDNotificationReceiver.h"
#import "CTDUtility/CTDPoint.h"




@interface CTDConnectionActivityTestCase : XCTestCase <CTDNotificationReceiver>

@property (strong, nonatomic) CTDConnectionActivity* subject;

// Collaborators
@property (strong, nonatomic) CTDTrialRendererSpy* trialRenderer;

// Test fixture
@property (copy, nonatomic) NSArray* dotPairs;
@property (strong, nonatomic) id<CTDTrial> trial;

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
    self.trial = [CTDModel trialWithDotPairs:self.dotPairs];
    self.trialRenderer = [[CTDTrialRendererSpy alloc] init];
    self.subject = [[CTDConnectionActivity alloc] initWithTrial:self.trial
                                                  trialRenderer:self.trialRenderer
                                                  trialCompletionNotificationReceiver:self];
}

- (NSArray*)trialCompletionNotificationSenders
{
    return [_trialCompletionNotificationSenders copy];
}

- (void)receiveNotification:(NSString*)notificationId
                 fromSender:(id)sender
                   withInfo:(__unused NSDictionary*)info
{
    if ([notificationId isEqualToString:CTDTrialCompletedNotification])
    {
        [_trialCompletionNotificationSenders addObject:sender];
    }
}

@end




@interface CTDConnectionActivityWhenFirstBegan : CTDConnectionActivityTestCase
@end
@implementation CTDConnectionActivityWhenFirstBegan

- (void)setUp
{
    [super setUp];
    [self.subject beginTrial];
}

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




@interface CTDConnectionActivityAfterConnectionAnchoredToFirstDot : CTDConnectionActivityTestCase
@end

@implementation CTDConnectionActivityAfterConnectionAnchoredToFirstDot
{
    id<CTDTrialStepConnectionEditor> _newConnectionEditor;
}

- (void)setUp
{
    [super setUp];
    [self.subject beginTrial];
    _newConnectionEditor = [[self.subject editorForCurrentStep] editorForNewConnection];
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

- (void)testThatReturnedConnectionEditorIsNotNil
{
    assertThat(_newConnectionEditor, is(notNilValue()));
}

@end




@interface CTDConnectionActivityWhenFreeEndOfConnectionChanges : CTDConnectionActivityTestCase
@end

@implementation CTDConnectionActivityWhenFreeEndOfConnectionChanges
{
    CTDPoint* _newFreeEndPosition;
}

- (void)setUp
{
    [super setUp];
    [self.subject beginTrial];
    id<CTDTrialStepConnectionEditor> connectionEditor =
        [[self.subject editorForCurrentStep] editorForNewConnection];
    _newFreeEndPosition = [CTDPoint x:50 y:290];
    [connectionEditor setFreeEndPosition:_newFreeEndPosition];
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




@interface CTDConnectionActivityAfterCompletingConnection : CTDConnectionActivityTestCase
@end

@implementation CTDConnectionActivityAfterCompletingConnection

- (void)setUp
{
    [super setUp];
    [self.subject beginTrial];
    id<CTDTrialStepConnectionEditor> connectionEditor =
        [[self.subject editorForCurrentStep] editorForNewConnection];
    [connectionEditor establishConnection];
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




@interface CTDConnectionActivityAfterCommittingConnection : CTDConnectionActivityTestCase
@property (strong, nonatomic) id<CTDTrialStepEditor> previousStepEditor;
@property (strong, nonatomic) CTDFakeDotRendering* previousStepFirstDotRendering;
@property (strong, nonatomic) CTDFakeDotRendering* previousStepSecondDotRendering;
@property (strong, nonatomic) CTDFakeConnectionRendering* previousStepConnectionRendering;
@end

@implementation CTDConnectionActivityAfterCommittingConnection

- (void)setUp
{
    [super setUp];
    [self.subject beginTrial];
    id<CTDTrialStepConnectionEditor> connectionEditor =
        [[self.subject editorForCurrentStep] editorForNewConnection];
    [connectionEditor establishConnection];

    // Save refs to current renderings so we can verify that they have been
    // hidden after the step has been completed.
    self.previousStepEditor = [self.subject editorForCurrentStep];
    self.previousStepFirstDotRendering = self.trialRenderer.dotRenderings[0];
    self.previousStepSecondDotRendering = self.trialRenderer.dotRenderings[1];
    self.previousStepConnectionRendering = self.trialRenderer.connectionRenderings[0];

    [connectionEditor commitConnectionState];
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

@end




@interface CTDConnectionActivityAfterBreakingEstablishedConnection : CTDConnectionActivityTestCase
@end

@implementation CTDConnectionActivityAfterBreakingEstablishedConnection
{
    CTDPoint* _newFreeEndPosition;
}

- (void)setUp
{
    [super setUp];
    [self.subject beginTrial];
    id<CTDTrialStepConnectionEditor> connectionEditor =
        [[self.subject editorForCurrentStep] editorForNewConnection];
    [connectionEditor establishConnection];
    _newFreeEndPosition = [CTDPoint x:4 y:36];
    [connectionEditor setFreeEndPosition:_newFreeEndPosition];
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




@interface CTDConnectionActivityAfterCancellingConnection : CTDConnectionActivityTestCase
@end

@implementation CTDConnectionActivityAfterCancellingConnection

- (void)setUp
{
    [super setUp];
    [self.subject beginTrial];
    id<CTDTrialStepConnectionEditor> connectionEditor =
        [[self.subject editorForCurrentStep] editorForNewConnection];
    [connectionEditor cancelConnection];
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




@interface CTDConnectionActivityStartingSecondConnectionAfterFirstCancelled : CTDConnectionActivityTestCase
@end
@implementation CTDConnectionActivityStartingSecondConnectionAfterFirstCancelled
{
    id<CTDTrialStepConnectionEditor> _connectionEditor;
}

- (void)setUp
{
    [super setUp];
    [self.subject beginTrial];
    id<CTDTrialStepEditor> trialStepEditor = [self.subject editorForCurrentStep];
    // Start and cancel one connection.
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

- (void)setUp
{
    [super setUp];
    [self.subject beginTrial];
    NSUInteger stepCount = [self.dotPairs count];
    for (NSUInteger stepIndex = 0; stepIndex < stepCount; stepIndex += 1)
    {
        [self.subject advanceToNextStep];
    }
}

//- (void)testThatTrialIsMarkedCompleted
//{
//}

- (void)testThatListenersAreNotifiedThatTheTrialIsComplete
{
    assertThat(self.trialCompletionNotificationSenders, hasItem(self.subject));
}

@end
