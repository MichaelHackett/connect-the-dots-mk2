// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTaskConfigurationScene.h"

#import "Ports/CTDTaskConfigurationSceneRenderer.h"



@interface CTDTaskConfigurationScene ()

@property (assign, nonatomic) NSUInteger formParticipantId;
@property (copy, nonatomic)   NSNumber*  formPreferredHand;
@property (copy, nonatomic)   NSNumber*  formInterfaceStyle;

@end



@implementation CTDTaskConfigurationScene


#pragma mark CTDTaskConfigurationForm protocol


- (void)setFormParticipantId:(NSUInteger)participantId
{
    _formParticipantId = participantId;

    ctd_strongify(self.sceneRenderer, sceneRenderer);
    [sceneRenderer setParticipantIdValue:@(participantId)];
    [sceneRenderer setParticipantIdString:
        [NSString stringWithFormat:@"%lu", (unsigned long)participantId]];
}

- (void)setFormPreferredHand:(NSNumber*)preferredHand
{
    _formPreferredHand = preferredHand;

    ctd_strongify(self.sceneRenderer, sceneRenderer);
    [sceneRenderer setPreferredHandIndex:preferredHand]; // 0-based index matches CTDHand values
}

- (void)setFormInterfaceStyle:(NSNumber*)interfaceStyle
{
    _formInterfaceStyle = interfaceStyle;

    ctd_strongify(self.sceneRenderer, sceneRenderer);
    [sceneRenderer setInterfaceStyleIndex:interfaceStyle]; // 0-based index matches CTDInterfaceStyle values
}

//- (void)setFormSequenceNumber:(NSUInteger)sequenceNumber
//{
//    _formSequenceNumber = sequenceNumber;
//
//    ctd_strongify(self.sceneRenderer, sceneRenderer);
//    [sceneRenderer setSequenceNumberValue:@(sequenceNumber)];
//    [sceneRenderer setSequenceNumberString:
//        [NSString stringWithFormat:@"%lu", (unsigned long)sequenceNumber]];
//}



#pragma mark CTDTaskConfigurationSceneInputRouter protocol


- (void)participantIdChangedTo:(NSUInteger)newParticipantId
{
    ctd_strongify(self.configurationFormEditor, configurationFormEditor);
    [configurationFormEditor changeParticipantIdTo:newParticipantId];
}

- (void)preferredHandChangedTo:(NSNumber*)newHandIndex
{
    ctd_strongify(self.configurationFormEditor, configurationFormEditor);
    [configurationFormEditor changePreferredHandTo:newHandIndex];
}

- (void)interfaceStyleChangedTo:(NSNumber*)newStyleIndex
{
    ctd_strongify(self.configurationFormEditor, configurationFormEditor);
    [configurationFormEditor changeInterfaceStyleTo:newStyleIndex];
}

- (void)formSubmissionButtonPressed
{
    ctd_strongify(self.configurationFormEditor, configurationFormEditor);
    [configurationFormEditor acceptConfiguration];
}

@end
