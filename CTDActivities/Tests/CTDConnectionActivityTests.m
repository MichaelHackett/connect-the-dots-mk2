// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDConnectionActivity.h"

#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDModel.h"
#import "CTDModel/CTDTrial.h"
#import "CTDPresentation/Ports/CTDTrialRenderer.h"
#import "CTDUtility/CTDPoint.h"



@interface CTDFakeDotRendering : NSObject

@property (copy, nonatomic) CTDPoint* centerPosition;
@property (copy, nonatomic) CTDPaletteColorLabel dotColor;

@end


@interface CTDTrialRendererSpy : NSObject <CTDTrialRenderer>

@property (strong, nonatomic, readonly) NSArray* dotRenderings; // of CTDFakeDotRenderings
@property (strong, nonatomic, readonly) NSArray* connectionRenderings; // of ???

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

- (void)testThatItAddsNoConnections
{
    assertThat(self.trialRenderer.connectionRenderings, hasCountOf(0));
}

@end





@implementation CTDFakeDotRendering
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

- (id<CTDDotRenderer,CTDTouchable>)
      newRendererForDotWithCenterPosition:(CTDPoint*)centerPosition
                             initialColor:(CTDPaletteColorLabel)dotColor
{
    CTDFakeDotRendering* dotRendering = [[CTDFakeDotRendering alloc] init];
    dotRendering.centerPosition = centerPosition;
    dotRendering.dotColor = dotColor;
    [_dotRenderings addObject:dotRendering];
    return nil;
}

- (id<CTDDotConnectionRenderer>)
    newRendererForDotConnectionWithFirstEndpointPosition:(__unused CTDPoint*)firstEndpointPosition
                                  secondEndpointPosition:(__unused CTDPoint*)secondEndpointPosition
{
    [_connectionRenderings addObject:@1];
    return nil;
}


- (NSArray*)dotRenderings
{
    return [_dotRenderings copy];
}

- (NSArray *)connectionRenderings
{
    return [_connectionRenderings copy];
}

@end
