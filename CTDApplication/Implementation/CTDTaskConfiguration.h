// CTDTaskConfiguration:
//     Parameters for the task, such as controls layout, sequence number, etc.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDModel/CTDTrial.h"



@protocol CTDTaskConfiguration <NSObject>

- (void)setParticipantId:(NSUInteger)participantId;
- (void)setPreferredHand:(CTDHand)preferredHand;
- (void)setInterfaceStyle:(CTDInterfaceStyle)interfaceStyle;
//- (void)setSequenceNumber:(NSUInteger)sequenceNumber;

@end
