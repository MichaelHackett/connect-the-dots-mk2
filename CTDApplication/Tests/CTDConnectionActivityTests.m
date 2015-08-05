// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDConnectionActivity.h"

#import "Ports/CTDTrialRenderer.h"

#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDModel.h"
#import "CTDModel/CTDTrial.h"
#import "CTDUtility/CTDPoint.h"



@interface CTDFakeDotRendering : NSObject <CTDDotRenderer>

@property (copy, readonly, nonatomic) CTDPoint* centerPosition;
@property (copy, readonly, nonatomic) CTDPaletteColorLabel dotColor;
@property (assign, readonly,nonatomic) BOOL hasSelectionIndicator;

@end


@interface CTDFakeConnectionRendering : NSObject <CTDDotConnectionRenderer>

@property (copy, nonatomic) CTDPoint* firstEndpointPosition;
@property (copy, nonatomic) CTDPoint* secondEndpointPosition;

@end


@interface CTDTrialRendererSpy : NSObject <CTDTrialRenderer>

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

- (void)testThatItRendersOnlyOneDot
{
    assertThat(self.trialRenderer.dotRenderings, hasCountOf(1));
}

- (void)testThatFirstDotIsRenderedInCorrectPosition
{
    assertThat([self.trialRenderer.dotRenderings[0] centerPosition],
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

- (void)testThatItAddsNoConnections
{
    assertThat(self.trialRenderer.connectionRenderings, hasCountOf(0));
}

@end



@interface CTDConnectionActivityAfterConnectionAnchoredToFirstDot : CTDConnectionActivityTestCase
@end

@implementation CTDConnectionActivityAfterConnectionAnchoredToFirstDot
{
    id<CTDDotConnection> _newConnectionResult;
}
- (void)setUp {
    [super setUp];
    [self.subject beginTrial];
    _newConnectionResult = [self.subject newConnection];
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
    assertThat([self.trialRenderer.dotRenderings[1] centerPosition],
               is(equalTo([self.dotPairs[0] endPosition])));
}

- (void)testThatSecondDotIsRenderedInSameColor
{
    assertThat([self.trialRenderer.dotRenderings[1] dotColor],
               is(equalTo(CTDPaletteColor_DotType1)));
}

- (void)testThatStartingDotIsNotRenderedAsActivated
{
    assertThatBool([self.trialRenderer.dotRenderings[1] hasSelectionIndicator],
                   is(equalToBool(NO)));
}

- (void)testThatConnectionIsCreated
{
    assertThat(self.trialRenderer.connectionRenderings, hasCountOf(1));
}

- (void)testThatConnectionIsAnchoredAtFirstDot
{
    CTDFakeConnectionRendering* connection = self.trialRenderer.connectionRenderings[0];
    assertThat(connection.firstEndpointPosition, is(equalTo([self.dotPairs[0] startPosition])));
}

- (void)testThatFreeEndOfConnectionIsTheSameAsTheAnchoredEnd
{
    CTDFakeConnectionRendering* connection = self.trialRenderer.connectionRenderings[0];
    assertThat(connection.secondEndpointPosition, is(equalTo([self.dotPairs[0] startPosition])));
}

- (void)testThatReturnedConnectionIsNotNil
{
    assertThat(_newConnectionResult, is(notNilValue()));
}

@end



@implementation CTDFakeDotRendering

- (instancetype)initWithCenterPosition:(CTDPoint*)centerPosition
                                 color:(CTDPaletteColorLabel)color
{
    self = [super init];
    if (self) {
        _centerPosition = [centerPosition copy];
        _dotColor = [color copy];
        _hasSelectionIndicator = NO;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithCenterPosition:[CTDPoint origin] color:nil];
}

- (CTDPoint*)dotConnectionPoint { return [CTDPoint origin]; }
- (void)setDotColor:(__unused CTDPaletteColorLabel)newDotColor {}

- (void)hideSelectionIndicator { _hasSelectionIndicator = NO; }
- (void)showSelectionIndicator { _hasSelectionIndicator = YES; }

@end



@implementation CTDFakeConnectionRendering

- (instancetype)init
{
    self = [super init];
    if (self) {
        _firstEndpointPosition = nil;
        _secondEndpointPosition = nil;
    }
    return self;
}

- (void)invalidate {}

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

- (id<CTDDotRenderer>)
      newRendererForDotWithCenterPosition:(CTDPoint*)centerPosition
                             initialColor:(CTDPaletteColorLabel)dotColor
{
    CTDFakeDotRendering* dotRendering = [[CTDFakeDotRendering alloc]
                                         initWithCenterPosition:centerPosition
                                         color:dotColor];
    [_dotRenderings addObject:dotRendering];
    return dotRendering;
}

- (id<CTDDotConnectionRenderer>)
    newRendererForDotConnectionWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                                  secondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    CTDFakeConnectionRendering* connectionRendering = [[CTDFakeConnectionRendering alloc] init];
    connectionRendering.firstEndpointPosition = firstEndpointPosition;
    connectionRendering.secondEndpointPosition = secondEndpointPosition;
    [_connectionRenderings addObject:connectionRendering];
    return connectionRendering;
}

- (NSArray*)dotRenderings
{
    return [_dotRenderings copy];
}

- (NSArray*)connectionRenderings
{
    return [_connectionRenderings copy];
}

@end
