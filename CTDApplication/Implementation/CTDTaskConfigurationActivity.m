// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTaskConfigurationActivity.h"

#import "CTDApplicationDefaults.h"
#import "CTDTaskConfiguration.h"



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

@end
