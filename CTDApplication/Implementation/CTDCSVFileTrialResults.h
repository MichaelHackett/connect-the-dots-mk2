// CTDCSVFileTrialResults:
//     Implementation of CTDTrialResults that stores results in CSV-format
//     files in the application filesystem.
//
//  Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDModel/CTDTrial.h"
#import "CTDModel/CTDTrialBlockResults.h"
#import "CTDModel/CTDTrialResults.h"
@class CTDStreamWriter;





@interface CTDCSVTrialBlockWriter : NSObject <CTDTrialBlockResults>

- (instancetype)initWithParticipantId:(NSUInteger)participantId
                        preferredHand:(CTDHand)preferredHand
                       interfaceStyle:(CTDInterfaceStyle)interfaceStyle
                   outputStreamWriter:(CTDStreamWriter*)outputStreamWriter;

CTD_NO_DEFAULT_INIT

// Move to protocol:
//- (NSUInteger)currentTrialIndex;  // auto-increments when beginNewTrial... is called?

//- (id<CTDTrialResults>)beginNewTrialWithSequenceId:(NSUInteger)sequenceId;

@end


@interface CTDCSVFileTrialWriter : NSObject <CTDTrialResults>

- (instancetype)initWithParticipantId:(NSUInteger)participantId
                        preferredHand:(CTDHand)preferredHand
                       interfaceStyle:(CTDInterfaceStyle)interfaceStyle
                           trialIndex:(NSUInteger)trialIndex
                           sequenceId:(NSUInteger)sequenceId
                         outputStream:(NSOutputStream*)outputStream;

CTD_NO_DEFAULT_INIT

@end
