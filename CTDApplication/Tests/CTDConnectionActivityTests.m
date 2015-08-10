// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDConnectionActivity.h"

#import "Ports/CTDTrialRenderer.h"

#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDModel.h"
#import "CTDModel/CTDTrial.h"
#import "CTDUtility/CTDPoint.h"
#import "CTDTrialRendererSpy.h"



@interface CTDConnectionActivityTestCase : XCTestCase

@property (strong, nonatomic) CTDConnectionActivity* subject;

// Collaborators
@property (strong, nonatomic) CTDTrialRendererSpy* trialRenderer;

// Test fixture
@property (copy, nonatomic) NSArray* dotPairs;
@property (strong, nonatomic) id<CTDTrial> trial;

@end



@implementation CTDConnectionActivityTestCase

- (void)setUp
{
    [super setUp];
    self.dotPairs = @[
        [CTDModel dotPairWithColor:CTDDotColor_Red
                     startPosition:[CTDPoint x:49 y:250]
                       endPosition:[CTDPoint x:500 y:20]],
        [CTDModel dotPairWithColor:CTDDotColor_Blue
                     startPosition:[CTDPoint x:275 y:50]
                       endPosition:[CTDPoint x:25 y:460]]
    ];
    self.trial = [CTDModel trialWithDotPairs:self.dotPairs];
    self.trialRenderer = [[CTDTrialRendererSpy alloc] init];
    self.subject = [[CTDConnectionActivity alloc] initWithTrial:self.trial
                                                  trialRenderer:self.trialRenderer];
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
    _newConnectionEditor = [[self.subject trialStepEditor] editorForNewConnection];
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
        [[self.subject trialStepEditor] editorForNewConnection];
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





@interface CTDConnectionActivityAfterCancellingConnection : CTDConnectionActivityTestCase
@end

@implementation CTDConnectionActivityAfterCancellingConnection

- (void)setUp
{
    [super setUp];
    [self.subject beginTrial];
    id<CTDTrialStepConnectionEditor> connectionEditor =
        [[self.subject trialStepEditor] editorForNewConnection];
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
    // Start and cancel one connection.
    [[[self.subject trialStepEditor] editorForNewConnection] cancelConnection];
    // Then start a second.
    _connectionEditor = [[self.subject trialStepEditor] editorForNewConnection];
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



