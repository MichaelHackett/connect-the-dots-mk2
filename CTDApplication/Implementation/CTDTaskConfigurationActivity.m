// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTaskConfigurationActivity.h"

#import "CTDApplicationDefaults.h"
#import "CTDTaskConfiguration.h"
#import "CTDUtility/CTDNotificationReceiver.h"



// Notification definitions
NSString * const CTDTaskConfigurationCompletedNotification = @"CTDTaskConfigurationCompletedNotification";



@implementation CTDTaskConfigurationActivity


#pragma mark CTDTaskConfigurationFormEditor protocol


- (void)resetForm
{
    ctd_strongify(self.taskConfigurationForm, form);
    [form setFormParticipantId:[CTDApplicationDefaults taskConfigurationFormDefaultParticipantId]];
    [form setFormPreferredHand:[CTDApplicationDefaults taskConfigurationFormDefaultPreferredHand]];
    [form setFormInterfaceStyle:[CTDApplicationDefaults taskConfigurationFormDefaultInterfaceStyle]];
//    [form setFormSequenceNumber:[CTDApplicationDefaults taskConfigurationFormDefaultSequenceNumber]];
}

- (void)acceptConfiguration
{
    ctd_strongify(self.taskConfigurationForm, form);
    if (![form formPreferredHand] || ![form formInterfaceStyle])
    {
        // Incomplete form --- do not accept. (TODO: Should have some notification to Scene.)
        return;
    }

    ctd_strongify(self.taskConfiguration, config);
    [config setParticipantId:[form formParticipantId]];
    [config setPreferredHand:[[form formPreferredHand] unsignedIntegerValue]];
    [config setInterfaceStyle:[[form formInterfaceStyle] unsignedIntegerValue]];

    ctd_strongify(self.notificationReceiver, notificationReceiver);
    [notificationReceiver receiveNotification:CTDTaskConfigurationCompletedNotification
                                   fromSender:self
                                     withInfo:nil];
}

- (void)changeParticipantIdTo:(NSUInteger)newParticipantId
{
    ctd_strongify(self.taskConfigurationForm, form);
    [form setFormParticipantId:newParticipantId];
}

- (void)changePreferredHandTo:(NSNumber*)newPreferredHand
{
    ctd_strongify(self.taskConfigurationForm, form);
    [form setFormPreferredHand:newPreferredHand];
}

- (void)changeInterfaceStyleTo:(NSNumber*)newInterfaceStyle
{
    ctd_strongify(self.taskConfigurationForm, form);
    [form setFormInterfaceStyle:newInterfaceStyle];
}

@end
