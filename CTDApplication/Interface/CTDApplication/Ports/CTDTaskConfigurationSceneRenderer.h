// CTDTaskConfigurationSceneRenderer:
//     A renderer for the task configuration scene model.
//
// Copyright 2015 Michael Hackett. All rights reserved.



@protocol CTDTaskConfigurationSceneRenderer <NSObject>

- (void)setParticipantIdValue:(NSNumber*)participantId;
- (void)setParticipantIdString:(NSString*)participantIdString;
- (void)setPreferredHandIndex:(NSNumber*)preferredHandIndex; // TODO: Use string resource refs?
- (void)setInterfaceStyleIndex:(NSNumber*)interfaceStyleIndex;
- (void)setSequenceNumberValue:(NSNumber*)sequenceNumber;
- (void)setSequenceNumberString:(NSString*)sequenceNumberString;

@end
