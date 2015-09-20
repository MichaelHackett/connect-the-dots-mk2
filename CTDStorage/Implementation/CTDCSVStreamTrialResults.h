// CTDCSVStreamTrialResults:
//     Implementation of CTDTrialResults that writes the results to a text
//     stream, in CSV-format.
//
//  Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDModel/CTDInMemoryTrialResults.h"
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


@interface CTDCSVStreamTrialResults : CTDInMemoryTrialResults <CTDTrialResults>

- (instancetype)initWithParticipantId:(NSUInteger)participantId
                        preferredHand:(CTDHand)preferredHand
                       interfaceStyle:(CTDInterfaceStyle)interfaceStyle
                          trialNumber:(NSUInteger)trialNumber
                           sequenceId:(NSUInteger)sequenceId
                   outputStreamWriter:(CTDStreamWriter*)outputStreamWriter;

CTD_NO_DEFAULT_INIT

@end
