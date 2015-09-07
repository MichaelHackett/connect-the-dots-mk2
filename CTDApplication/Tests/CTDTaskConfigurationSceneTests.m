// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTaskConfigurationScene.h"

#import "CTDTaskConfigurationActivity.h"
#import "Ports/CTDTaskConfigurationSceneRenderer.h"



@interface CTDTaskConfigurationSceneTestCase : XCTestCase

@property (strong, nonatomic) CTDTaskConfigurationScene* subject;

@end

@implementation CTDTaskConfigurationSceneTestCase

- (void)setUp
{
    [super setUp];
    self.subject = [[CTDTaskConfigurationScene alloc] init];
}

@end



@interface CTDTaskConfigurationSceneFormProtocolTests
    : CTDTaskConfigurationSceneTestCase <CTDTaskConfigurationSceneRenderer>

// Indirect outputs (Presentation Model)
@property (copy, nonatomic) NSNumber* participantIdValue;
@property (copy, nonatomic) NSString* participantIdString;
@property (copy, nonatomic) NSNumber* preferredHandIndex;
@property (copy, nonatomic) NSNumber* interfaceStyleIndex;
//@property (copy, nonatomic) NSNumber* sequenceNumberValue;
//@property (copy, nonatomic) NSString* sequenceNumberString;

@end

@implementation CTDTaskConfigurationSceneFormProtocolTests

- (void)setUp
{
    [super setUp];
    self.subject.sceneRenderer = self;
}

- (void)testThatChangesToFormParticipantIdAreReflectedInPresentationString
{
    self.participantIdString = nil;
    [self.subject setFormParticipantId:46];
    assertThat(self.participantIdString, is(equalTo(@"46")));
    [self.subject setFormParticipantId:1];
    assertThat(self.participantIdString, is(equalTo(@"1")));
}

- (void)testThatChangesToFormParticipantIdAreReflectedInPresentationValue
{
    self.participantIdValue = nil;
    [self.subject setFormParticipantId:46];
    assertThat(self.participantIdValue, is(equalTo(@46)));
    [self.subject setFormParticipantId:1];
    assertThat(self.participantIdValue, is(equalTo(@1)));
}

- (void)testThatChangesToFormPreferredHandAreReflectedInPresentationSelection
{
    self.preferredHandIndex = nil;
    [self.subject setFormPreferredHand:@2];
    assertThat(self.preferredHandIndex, is(equalTo(@2)));
    [self.subject setFormPreferredHand:nil];
    assertThat(self.preferredHandIndex, is(nilValue()));
}

- (void)testThatChangesToFormInterfaceStyleAreReflectedInPresentationSelection
{
    self.interfaceStyleIndex = nil;
    [self.subject setFormInterfaceStyle:@1];
    assertThat(self.interfaceStyleIndex, is(equalTo(@1)));
    [self.subject setFormInterfaceStyle:nil];
    assertThat(self.interfaceStyleIndex, is(nilValue()));
}

//- (void)testThatChangesToFormSequenceNumberAreReflectedInPresentationString
//{
//    self.sequenceNumberString = nil;
//    [self.subject setFormSequenceNumber:18];
//    assertThat(self.sequenceNumberString, is(equalTo(@"18")));
//    [self.subject setFormSequenceNumber:3];
//    assertThat(self.sequenceNumberString, is(equalTo(@"3")));
//}
//
//- (void)testThatChangesToFormSequenceNumberAreReflectedInPresentationValue
//{
//    self.sequenceNumberValue = nil;
//    [self.subject setFormSequenceNumber:18];
//    assertThat(self.sequenceNumberValue, is(equalTo(@18)));
//    [self.subject setFormSequenceNumber:3];
//    assertThat(self.sequenceNumberValue, is(equalTo(@3)));
//}

@end




@interface CTDTaskConfigurationSceneInputRouterTestCase
    : CTDTaskConfigurationSceneTestCase <CTDTaskConfigurationFormEditor>

// Indirect outputs (Form Editor)
@property (assign, nonatomic) NSUInteger participantId;
@property (copy, nonatomic)   NSNumber* preferredHand;
@property (copy, nonatomic)   NSNumber* interfaceStyle;
@property (assign, nonatomic) BOOL configurationAccepted;

@end

@implementation CTDTaskConfigurationSceneInputRouterTestCase

- (void)setUp
{
    [super setUp];
    self.subject.configurationFormEditor = self;
}


// CTDTaskConfigurationFormEditor protocol

- (void)resetForm {}

- (void)acceptConfiguration
{
    self.configurationAccepted = YES;
}

- (void)changeParticipantIdTo:(NSUInteger)newParticipantId
{
    self.participantId = newParticipantId;
}

- (void)changePreferredHandTo:(NSNumber*)newPreferredHand
{
    self.preferredHand = newPreferredHand;
}

- (void)changeInterfaceStyleTo:(NSNumber*)newInterfaceStyle
{
    self.interfaceStyle = newInterfaceStyle;
}

@end




@interface CTDTaskConfigurationSceneWhenFormSubmissionButtonPressed
    : CTDTaskConfigurationSceneInputRouterTestCase
@end
@implementation CTDTaskConfigurationSceneWhenFormSubmissionButtonPressed

- (void)setUp
{
    [super setUp];
    self.configurationAccepted = NO;
    [self.subject formSubmissionButtonPressed];
}

- (void)testThatItTellsTheFormEditorToAcceptTheConfiguration
{
    assertThatBool(self.configurationAccepted, is(equalToBool(YES)));
}

@end




@interface CTDTaskConfigurationSceneWhenParticipantIdStepChanges
    : CTDTaskConfigurationSceneInputRouterTestCase
@end
@implementation CTDTaskConfigurationSceneWhenParticipantIdStepChanges

- (void)setUp
{
    [super setUp];
    self.participantId = 5;
    [self.subject participantIdChangedTo:6];
}

- (void)testThatItAsksEditorToChangeTheParticipantIdInTheForm
{
    assertThatUnsignedInteger(self.participantId, is(equalToUnsignedInteger(6)));
}

@end




@interface CTDTaskConfigurationSceneWhenPreferredHandChanges
    : CTDTaskConfigurationSceneInputRouterTestCase
@end
@implementation CTDTaskConfigurationSceneWhenPreferredHandChanges

- (void)setUp
{
    [super setUp];
    self.preferredHand = nil;
    [self.subject preferredHandChangedTo:@1];
}

- (void)testThatItAsksEditorToChangeThePreferredHandIndexInTheForm
{
    assertThat(self.preferredHand, is(equalTo(@1)));
}

@end




@interface CTDTaskConfigurationSceneWhenInterfaceStyleChanges
    : CTDTaskConfigurationSceneInputRouterTestCase
@end
@implementation CTDTaskConfigurationSceneWhenInterfaceStyleChanges

- (void)setUp
{
    [super setUp];
    self.interfaceStyle = nil;
    [self.subject interfaceStyleChangedTo:@2];
}

- (void)testThatItAsksEditorToChangeThePreferredHandIndexInTheForm
{
    assertThat(self.interfaceStyle, is(equalTo(@2)));
}

@end
