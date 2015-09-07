// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTaskConfigurationScene.h"

#import "Ports/CTDTaskConfigurationSceneRenderer.h"



@implementation CTDTaskConfigurationScene


#pragma mark CTDTaskConfigurationForm protocol


- (void)setFormParticipantId:(NSUInteger)participantId
{
    ctd_strongify(self.sceneRenderer, sceneRenderer);
    [sceneRenderer setParticipantIdValue:@(participantId)];
    [sceneRenderer setParticipantIdString:
        [NSString stringWithFormat:@"%lu", (unsigned long)participantId]];
}

- (void)setFormPreferredHand:(NSNumber*)preferredHand
{
    ctd_strongify(self.sceneRenderer, sceneRenderer);
    [sceneRenderer setPreferredHandIndex:preferredHand]; // 0-based index matches CTDHand values
}

- (void)setFormInterfaceStyle:(NSNumber*)interfaceStyle
{
    ctd_strongify(self.sceneRenderer, sceneRenderer);
    [sceneRenderer setInterfaceStyleIndex:interfaceStyle]; // 0-based index matches CTDInterfaceStyle values
}

- (void)setFormSequenceNumber:(NSUInteger)sequenceNumber
{
    ctd_strongify(self.sceneRenderer, sceneRenderer);
    [sceneRenderer setSequenceNumberValue:@(sequenceNumber)];
    [sceneRenderer setSequenceNumberString:
        [NSString stringWithFormat:@"%lu", (unsigned long)sequenceNumber]];
}



#pragma mark CTDTaskConfigurationSceneInputRouter protocol


- (void)participantIdChangedTo:(NSUInteger)newParticipantId
{
    ctd_strongify(self.configurationFormEditor, configurationFormEditor);
    [configurationFormEditor changeParticipantIdTo:newParticipantId];
}

- (void)formSubmissionButtonPressed
{
    ctd_strongify(self.configurationFormEditor, configurationFormEditor);
    [configurationFormEditor acceptConfiguration];
}

@end
