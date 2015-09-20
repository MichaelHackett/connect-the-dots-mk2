// CTDTrialResultsFactory:
//     Used to obtain an interface for storing the results of a trial or trial
//     block.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDModel/CTDTrial.h"
@protocol CTDTrialBlockResults;
@protocol CTDTrialResults;



@protocol CTDTrialResultsFactory <NSObject>

- (id<CTDTrialBlockResults>)
      trialBlockResultsForParticipantId:(NSUInteger)participantId
                          preferredHand:(CTDHand)preferredHand
                         interfaceStyle:(CTDInterfaceStyle)interfaceStyle
                                  error:(NSError**)error;

- (id<CTDTrialResults>)
      trialResultsForParticipantId:(NSUInteger)participantId
                     preferredHand:(CTDHand)preferredHand
                    interfaceStyle:(CTDInterfaceStyle)interfaceStyle
                       trialNumber:(NSUInteger)trialNumber
                        sequenceId:(NSUInteger)sequenceId
                             error:(NSError**)error;

@end

// TODO: Remove parameters that aren't really required (e.g., preferredHand),
// and either add setters to Results protocol or make them properties of other
// objects. (e.g., preferredHand is really a property of a Participant)
//
// For TrialBlockResults, replace participantId and preferredHand with Participant
// For TrialResults, replace participantId, preferredHand, and interfaceStyle with
//     TrialBlock or TaskConfiguration
