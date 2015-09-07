// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTaskConfigurationActivity.h"

#import "CTDApplicationDefaults.h"
#import "CTDTaskConfiguration.h"
#import "CTDUtility/CTDNotificationReceiver.h"

#import "CTDNotificationRecorder.h"



@interface CTDTaskConfigurationActivityTestCase : XCTestCase <CTDTaskConfigurationForm>

@property (strong, nonatomic) CTDTaskConfigurationActivity* subject;

// Indirect outputs (CTDTaskConfigurationForm)
@property (assign, nonatomic) NSUInteger formParticipantId;
@property (copy, nonatomic) NSNumber* formPreferredHand;
@property (copy, nonatomic) NSNumber* formInterfaceStyle;
@property (assign, nonatomic) NSUInteger formSequenceNumber;

// Collaborators:
@property (strong, nonatomic) CTDNotificationRecorder* notificationRecorder;

@end

@implementation CTDTaskConfigurationActivityTestCase

- (void)setUp
{
    [super setUp];

    self.notificationRecorder = [[CTDNotificationRecorder alloc] init];

    self.subject = [[CTDTaskConfigurationActivity alloc] init];
    self.subject.taskConfigurationForm = self;
    self.subject.notificationReceiver = self.notificationRecorder;
}

- (void)testThatFormValuesAreSetToDefaultsAfterFormIsReset
{
    // scramble form values before resetting
    self.formParticipantId = 99;
    self.formPreferredHand = @99;
    self.formInterfaceStyle = @99;
    self.formSequenceNumber = 99;

    // exercise
    [self.subject resetForm];

    // verification
    NSUInteger defaultParticipantId = [CTDApplicationDefaults taskConfigurationFormDefaultParticipantId];
    NSNumber* defaultPreferredHand = [CTDApplicationDefaults taskConfigurationFormDefaultPreferredHand];
    NSNumber* defaultInterfaceStyle = [CTDApplicationDefaults taskConfigurationFormDefaultInterfaceStyle];
    NSUInteger defaultSequenceNumber = [CTDApplicationDefaults taskConfigurationFormDefaultSequenceNumber];

    assertThatUnsignedInteger(self.formParticipantId,
                              is(equalToUnsignedInteger(defaultParticipantId)));
    assertThat(self.formPreferredHand, is(equalTo(defaultPreferredHand)));
    assertThat(self.formInterfaceStyle, is(equalTo(defaultInterfaceStyle)));
    assertThatUnsignedInteger(self.formSequenceNumber,
                              is(equalToUnsignedInteger(defaultSequenceNumber)));
}

- (void)testThatCompletionNotificationIsSentWhenConfigurationFormIsAccepted
{
    [self.subject acceptConfiguration];
    assertThat(self.notificationRecorder.receivedNotifications,
               hasItem(allOf(hasProperty(@"sender", sameInstance(self.subject)),
                             hasProperty(@"notificationId", CTDTaskConfigurationCompletedNotification),
                             nil)));
}

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

// TODO: Range checking; but current UI prevents out-of-range values, so ignoring it for now.

@end
