// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTaskConfigurationActivity.h"

#import "CTDApplicationDefaults.h"
#import "CTDTaskConfiguration.h"
#import "CTDUtility/CTDNotificationReceiver.h"

#import "CTDNotificationRecorder.h"



@interface CTDTaskConfigurationActivityTestCase : XCTestCase <CTDTaskConfigurationForm>

@property (strong, nonatomic) CTDTaskConfigurationActivity* subject;

// Indirect inputs/outputs (CTDTaskConfigurationForm)
@property (assign, nonatomic) NSUInteger formParticipantId;
@property (copy, nonatomic) NSNumber* formPreferredHand;
@property (copy, nonatomic) NSNumber* formInterfaceStyle;
//@property (assign, nonatomic) NSUInteger formSequenceNumber;

@end

@implementation CTDTaskConfigurationActivityTestCase

- (void)setUp
{
    [super setUp];
    self.subject = [[CTDTaskConfigurationActivity alloc] init];
    self.subject.taskConfigurationForm = self;
}

@end




@interface CTDTaskConfigurationActivityWhenFormIsReset : CTDTaskConfigurationActivityTestCase
@end

@implementation CTDTaskConfigurationActivityWhenFormIsReset

- (void)setUp
{
    [super setUp];

    // scramble form values before resetting
    self.formParticipantId = 99;
    self.formPreferredHand = @99;
    self.formInterfaceStyle = @99;
//    self.formSequenceNumber = 99;

    // exercise
    [self.subject resetForm];
}

- (void)testThatFormValuesAreSetToDefaults
{
    // verification
    NSUInteger defaultParticipantId = [CTDApplicationDefaults taskConfigurationFormDefaultParticipantId];
    NSNumber* defaultPreferredHand = [CTDApplicationDefaults taskConfigurationFormDefaultPreferredHand];
    NSNumber* defaultInterfaceStyle = [CTDApplicationDefaults taskConfigurationFormDefaultInterfaceStyle];
//    NSUInteger defaultSequenceNumber = [CTDApplicationDefaults taskConfigurationFormDefaultSequenceNumber];

    assertThatUnsignedInteger(self.formParticipantId,
                              is(equalToUnsignedInteger(defaultParticipantId)));
    assertThat(self.formPreferredHand, is(equalTo(defaultPreferredHand)));
    assertThat(self.formInterfaceStyle, is(equalTo(defaultInterfaceStyle)));
//    assertThatUnsignedInteger(self.formSequenceNumber,
//                              is(equalToUnsignedInteger(defaultSequenceNumber)));
}

@end





@interface CTDTaskConfigurationActivityFormSubmissionTestCase
    : CTDTaskConfigurationActivityTestCase <CTDTaskConfiguration>

// Indirect outputs (CTDTaskConfiguration)
@property (copy, nonatomic) NSNumber* modelParticipantId; // NSUInteger
@property (copy, nonatomic) NSNumber* modelPreferredHand; // CTDHand
@property (copy, nonatomic) NSNumber* modelInterfaceStyle; // CTDInterfaceStyle
//@property (copy, nonatomic) NSNumber* modelSequenceNumber; // NSUInteger

// Collaborators:
@property (strong, nonatomic) CTDNotificationRecorder* notificationRecorder;

@end

@implementation CTDTaskConfigurationActivityFormSubmissionTestCase

- (void)setUp
{
    [super setUp];

    // nil means no new value has been received thru CTDTaskConfiguration setters
    self.modelParticipantId = nil;
    self.modelPreferredHand = nil;
    self.modelInterfaceStyle = nil;

    self.notificationRecorder = [[CTDNotificationRecorder alloc] init];

    self.subject.taskConfiguration = self;
    self.subject.taskConfigurationForm = self;
    self.subject.notificationReceiver = self.notificationRecorder;
}


// CTDTaskConfiguration protocol
// - store values wrapped in NSNumbers, to differentiate between "no value" (nil)

- (void)setParticipantId:(NSUInteger)participantId
{
    self.modelParticipantId = @(participantId);
}

- (void)setPreferredHand:(CTDHand)preferredHand
{
    self.modelPreferredHand = @(preferredHand);
}

- (void)setInterfaceStyle:(CTDInterfaceStyle)interfaceStyle
{
    self.modelInterfaceStyle = @(interfaceStyle);
}

@end



@interface CTDTaskConfigurationActivityInvalidFormSubmissionTestCase
    : CTDTaskConfigurationActivityFormSubmissionTestCase
@end

@implementation CTDTaskConfigurationActivityInvalidFormSubmissionTestCase

- (void)setUp
{
    [super setUp];
    self.formParticipantId = 1;
    self.formPreferredHand = @(CTDLeftHand);
    self.formInterfaceStyle = @(CTDModalInterfaceStyle);
    [self.notificationRecorder reset];
}


//
// Common tests for all subcases
//

- (void)testThatAppModelConfigIsUnchanged
{
    assertThat(self.modelParticipantId, is(nilValue()));
    assertThat(self.modelPreferredHand, is(nilValue()));
    assertThat(self.modelInterfaceStyle, is(nilValue()));
}

- (void)testThatNoCompletionNotificationIsSent
{
    assertThat(self.notificationRecorder.receivedNotifications, hasCountOf(0));
}

@end



@interface CTDTaskConfigurationActivityWhenFormIsSubmittedWithoutPreferredHandSelection
    : CTDTaskConfigurationActivityInvalidFormSubmissionTestCase
@end

@implementation CTDTaskConfigurationActivityWhenFormIsSubmittedWithoutPreferredHandSelection

- (void)setUp
{
    [super setUp];
    self.formPreferredHand = nil; // *** invalid: no selection
    // exercise
    [self.subject acceptConfiguration];
}

@end



@interface CTDTaskConfigurationActivityWhenFormIsSubmittedWithoutInterfaceStyleSelection
    : CTDTaskConfigurationActivityInvalidFormSubmissionTestCase
@end

@implementation CTDTaskConfigurationActivityWhenFormIsSubmittedWithoutInterfaceStyleSelection

- (void)setUp
{
    [super setUp];
    self.formInterfaceStyle = nil; // *** invalid: no selection
    // exercise
    [self.subject acceptConfiguration];
}

@end



@interface CTDTaskConfigurationActivityWhenFormIsAccepted
    : CTDTaskConfigurationActivityFormSubmissionTestCase
@end

@implementation CTDTaskConfigurationActivityWhenFormIsAccepted

- (void)setUp
{
    [super setUp];
    self.formParticipantId = 27;
    self.formPreferredHand = @(CTDLeftHand);
    self.formInterfaceStyle = @(CTDQuasimodalInterfaceStyle);
    [self.notificationRecorder reset];
    // exercise
    [self.subject acceptConfiguration];
}

- (void)testThatAppModelConfigurationIsUpdated
{
    assertThat(self.modelParticipantId, is(equalTo(@(self.formParticipantId))));
    assertThat(self.modelPreferredHand, is(equalTo(self.formPreferredHand)));
    assertThat(self.modelInterfaceStyle, is(equalTo(self.formInterfaceStyle)));
}

- (void)testThatCompletionNotificationIsSent
{
    assertThat(self.notificationRecorder.receivedNotifications,
               hasItem(allOf(hasProperty(@"sender", sameInstance(self.subject)),
                             hasProperty(@"notificationId", CTDTaskConfigurationCompletedNotification),
                             nil)));
}

@end





@interface CTDTaskConfigurationActivityWhenFormFieldIsChanged : CTDTaskConfigurationActivityTestCase
@end

@implementation CTDTaskConfigurationActivityWhenFormFieldIsChanged

- (void)testThatParticipantIdChangeRequestCausesFormToBeUpdated
{
    self.formParticipantId = 0;
    [self.subject changeParticipantIdTo:37];
    assertThatUnsignedInteger(self.formParticipantId, is(equalToUnsignedInteger(37)));
    [self.subject changeParticipantIdTo:11];
    assertThatUnsignedInteger(self.formParticipantId, is(equalToUnsignedInteger(11)));
}

- (void)testThatPreferredHandChangeRequestCausesFormToBeUpdated
{
    self.formPreferredHand = nil;
    [self.subject changePreferredHandTo:@1];
    assertThat(self.formPreferredHand, is(equalTo(@1)));
    [self.subject changePreferredHandTo:nil];
    assertThat(self.formPreferredHand, is(nilValue()));
}

- (void)testThatInterfaceStyleChangeRequestCausesFormToBeUpdated
{
    self.formInterfaceStyle = nil;
    [self.subject changeInterfaceStyleTo:@2];
    assertThat(self.formInterfaceStyle, is(equalTo(@2)));
    [self.subject changeInterfaceStyleTo:nil];
    assertThat(self.formInterfaceStyle, is(nilValue()));
}

// TODO: Range checking; but current UI prevents out-of-range values, so ignoring it for now.

@end
