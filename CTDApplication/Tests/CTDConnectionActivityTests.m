// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDConnectionActivity.h"

#import "Ports/CTDTrialRenderer.h"

#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDModel.h"
#import "CTDModel/CTDTrial.h"
#import "CTDUtility/CTDPoint.h"



@interface CTDFakeDotRendering : NSObject <CTDDotRenderer>

// Configuration:
@property (copy, nonatomic) void (^cancellationBlock)(void);

// Captured rendering state:
@property (copy, readonly, nonatomic) CTDPoint* dotCenterPosition;
@property (copy, readonly, nonatomic) CTDPaletteColorLabel dotColor;
@property (assign, readonly, nonatomic) BOOL isVisible;
@property (assign, readonly, nonatomic) BOOL hasSelectionIndicator;

@end


@interface CTDFakeConnectionRendering : NSObject <CTDDotConnectionRenderer>

// Configuration:
@property (copy, nonatomic) void (^cancellationBlock)(void);

// Captured rendering state:
@property (copy, nonatomic) CTDPoint* firstEndpointPosition;
@property (copy, nonatomic) CTDPoint* secondEndpointPosition;
@property (assign, readonly, nonatomic) BOOL isVisible;

@end


@interface CTDTrialRendererSpy : NSObject <CTDTrialRenderer>

// Both of these return only the currently visible renderings. This is so that
// tests don't need to care whether the implementation creates renderings only
// when needed for display, or pre-creates them hidden and just shows and hides
// them as needed.
@property (strong, nonatomic, readonly) NSArray* dotRenderings; // of CTDFakeDotRenderings
@property (strong, nonatomic, readonly) NSArray* connectionRenderings; // of CTDFakeConnectionRendering

@end



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
    assertThat(_newConnectionEditor, is(notNilValue()));
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



@implementation CTDFakeDotRendering

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _cancellationBlock = nil;
        _dotCenterPosition = [CTDPoint origin];
        _dotColor = nil;
        _isVisible = NO;
        _hasSelectionIndicator = NO;
    }
    return self;
}

- (void)discardRendering
{
    self.cancellationBlock();
}

- (void)setDotCenterPosition:(CTDPoint*)centerPosition
{
    _dotCenterPosition = [centerPosition copy];
}

- (void)setDotColor:(CTDPaletteColorLabel)newDotColor
{
    _dotColor = [newDotColor copy];
}

- (void)setVisible:(BOOL)visible { _isVisible = visible; }
- (void)hideSelectionIndicator { _hasSelectionIndicator = NO; }
- (void)showSelectionIndicator { _hasSelectionIndicator = YES; }

- (CTDPoint*)dotConnectionPoint {
    // Return an arbitrarily different value for the connection point (based
    // on the given position), so tests can distinguish that connection code
    // is using this value and not the one right from the trial step data.
    return [CTDPoint x:(999 - self.dotCenterPosition.x)
                     y:(999 - self.dotCenterPosition.y)];
}

@end



@implementation CTDFakeConnectionRendering

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _cancellationBlock = nil;
        _firstEndpointPosition = nil;
        _secondEndpointPosition = nil;
        _isVisible = NO;
    }
    return self;
}

- (void)discardRendering
{
    self.cancellationBlock();
}

- (void)setVisible:(BOOL)visible { _isVisible = visible; }

@end



@implementation CTDTrialRendererSpy
{
    NSMutableArray* _dotRenderings;
    NSMutableArray* _connectionRenderings;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dotRenderings = [[NSMutableArray alloc] init];
        _connectionRenderings = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id<CTDDotRenderer>)newRendererForDot
{
    CTDFakeDotRendering* dotRendering = [[CTDFakeDotRendering alloc] init];
    [_dotRenderings addObject:dotRendering];
    return dotRendering;
}

- (id<CTDDotConnectionRenderer>)newRendererForDotConnection
{
    CTDFakeConnectionRendering* connectionRendering = [[CTDFakeConnectionRendering alloc] init];

    ctd_weakify(self, weakSelf);
    ctd_weakify(connectionRendering, weakConnectionRendering);
    connectionRendering.cancellationBlock = ^{
        ctd_strongify(weakSelf, strongSelf);
        ctd_strongify(weakConnectionRendering, strongConnectionRendering);
        [strongSelf->_connectionRenderings removeObject:strongConnectionRendering];
    };

    [_connectionRenderings addObject:connectionRendering];
    return connectionRendering;
}

- (NSArray*)dotRenderings
{
    return [_dotRenderings filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat:@"isVisible == YES"]];
}

- (NSArray*)connectionRenderings
{
    return [_connectionRenderings filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat:@"isVisible == YES"]];
}

@end
