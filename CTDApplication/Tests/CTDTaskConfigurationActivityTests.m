// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTaskConfigurationActivity.h"

#import "CTDApplicationDefaults.h"
#import "CTDTaskConfiguration.h"
#import "CTDUtility/CTDNotificationReceiver.h"



@interface CTDTaskConfigurationActivityTestCase
    : XCTestCase <CTDTaskConfigurationForm>

@property (strong, nonatomic) CTDTaskConfigurationActivity* subject;

// Indirect outputs (CTDTaskConfigurationForm)
@property (assign, nonatomic) NSUInteger formParticipantId;
@property (copy, nonatomic) NSNumber* formPreferredHand;
@property (copy, nonatomic) NSNumber* formInterfaceStyle;
@property (assign, nonatomic) NSUInteger formSequenceNumber;

@end

@implementation CTDTaskConfigurationActivityTestCase

- (void)setUp
{
    [super setUp];
    self.subject = [[CTDTaskConfigurationActivity alloc] init];
    self.subject.taskConfigurationForm = self;
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

@end
