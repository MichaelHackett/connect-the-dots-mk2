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
    [form setFormSequenceNumber:[CTDApplicationDefaults taskConfigurationFormDefaultSequenceNumber]];
}

- (void)acceptConfiguration
{
    ctd_strongify(self.notificationReceiver, notificationReceiver);
    [notificationReceiver receiveNotification:CTDTaskConfigurationCompletedNotification
                                   fromSender:self
                                     withInfo:nil];
}

@end
