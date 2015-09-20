// CTDCSVStreamTrialResults:
//     Implementation of CTDTrialResults that writes the results to a text
//     stream, in CSV-format.
//
//  Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDModel/CTDTrial.h"
#import "CTDModel/CTDTrialBlockResults.h"
#import "CTDModel/CTDTrialResults.h"
@class CTDStreamWriter;




@interface CTDCSVStreamTrialBlockResults : NSObject <CTDTrialBlockResults>

- (instancetype)initWithParticipantId:(NSUInteger)participantId
                        preferredHand:(CTDHand)preferredHand
                       interfaceStyle:(CTDInterfaceStyle)interfaceStyle
                   outputStreamWriter:(CTDStreamWriter*)outputStreamWriter;

CTD_NO_DEFAULT_INIT

@end


@interface CTDCSVStreamTrialResults : NSObject <CTDTrialResults>

- (instancetype)initWithParticipantId:(NSUInteger)participantId
                        preferredHand:(CTDHand)preferredHand
                       interfaceStyle:(CTDInterfaceStyle)interfaceStyle
                           trialIndex:(NSUInteger)trialIndex
                           sequenceId:(NSUInteger)sequenceId
                         outputStream:(NSOutputStream*)outputStream;

CTD_NO_DEFAULT_INIT

@end
