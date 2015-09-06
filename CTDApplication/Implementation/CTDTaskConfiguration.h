// CTDTaskConfiguration:
//     Parameters for the task, such as controls layout, sequence number, etc.
//
// Copyright 2015 Michael Hackett. All rights reserved.


typedef enum
{
    CTDLeftHand,
    CTDRightHand
} CTDHand;

typedef enum
{
    CTDModalInterfaceStyle,
    CTDQuasimodalInterfaceStyle
} CTDInterfaceStyle;



@protocol CTDTaskConfiguration <NSObject>

- (void)setParticipantId:(NSUInteger)participantId;
- (void)setPreferredHand:(CTDHand)preferredHand;
- (void)setInterfaceStyle:(CTDInterfaceStyle)interfaceStyle;
- (void)setSequenceNumber:(NSUInteger)sequenceNumber;

@end
