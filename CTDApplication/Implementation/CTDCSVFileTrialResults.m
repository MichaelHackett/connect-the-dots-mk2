// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDCSVFileTrialResults.h"



@interface CTDCSVTrialBlockWriter () <NSStreamDelegate>
@end


@implementation CTDCSVTrialBlockWriter
{
    NSOutputStream* _outputStream;
    NSUInteger _participantId;
    CTDHand    _preferredHand;
    CTDInterfaceStyle _interfaceStyle;
}

- (instancetype)initWithParticipantId:(NSUInteger)participantId
                        preferredHand:(CTDHand)preferredHand
                       interfaceStyle:(CTDInterfaceStyle)interfaceStyle
                         outputStream:(NSOutputStream*)outputStream
{
    self = [super init];
    if (self)
    {
        _outputStream = outputStream;
        _participantId = participantId;
        _preferredHand = preferredHand;
        _interfaceStyle = interfaceStyle;

        outputStream.delegate = self;
    }
    return self;
}

- (void)setDuration:(NSTimeInterval)trialDuration
     forTrialNumber:(NSUInteger)trialNumber
         sequenceId:(NSUInteger)sequenceId
{
    NSString* line = [NSString stringWithFormat:@"%lu, %c, %c, %lu, %lu, %.2f\n",
                      (unsigned long)_participantId,
                      _preferredHand == CTDLeftHand ? 'L' : 'R',
                      _interfaceStyle == CTDModalInterfaceStyle ? 'M': 'Q',
                      (unsigned long)trialNumber,
                      (unsigned long)sequenceId,
                      (double)trialDuration];

    // TEMP: write directly
    NSData* data = [line dataUsingEncoding:NSASCIIStringEncoding];
    [_outputStream write:[data bytes] maxLength:[data length]];
}



#pragma mark - NSStreamDelegate


- (void)stream:(__unused NSStream*)stream
   handleEvent:(NSStreamEvent)eventCode
{
    switch(eventCode) {
        case NSStreamEventOpenCompleted:
//            [self ConnectionEndpoint_openCompletedForStream:stream];
            break;
        case NSStreamEventHasBytesAvailable:
//            [self ConnectionEndpoint_dataAvailableFromStream:stream];
            break;
        case NSStreamEventHasSpaceAvailable:
//            [self ConnectionEndpoint_spaceAvailableOnStream:stream];
            break;
        case NSStreamEventErrorOccurred:
//            [self ConnectionEndpoint_error:[stream streamError] occurredOnStream:stream];
            break;
        case NSStreamEventEndEncountered:
//            [self ConnectionEndpoint_encounteredEndOfStream:stream];
            break;
        default:
            break;
    }
}

@end





@implementation CTDCSVFileTrialWriter
{
    NSOutputStream* _outputStream;
    NSUInteger _participantId;
    CTDHand    _preferredHand;
    CTDInterfaceStyle _interfaceStyle;
    NSUInteger _trialIndex;
    NSUInteger _sequenceId;
}

- (instancetype)initWithParticipantId:(NSUInteger)participantId
                        preferredHand:(CTDHand)preferredHand
                       interfaceStyle:(CTDInterfaceStyle)interfaceStyle
                           trialIndex:(NSUInteger)trialIndex
                           sequenceId:(NSUInteger)sequenceId
                         outputStream:(NSOutputStream*)outputStream
{
    self = [super init];
    if (self)
    {
        _outputStream = outputStream;
        _participantId = participantId;
        _preferredHand = preferredHand;
        _interfaceStyle = interfaceStyle;
        _trialIndex = trialIndex;
        _sequenceId = sequenceId;

//        NSString* fileName = [NSString stringWithFormat:@"p%lu%c-%lu.csv",
//                              (unsigned long)participantId,
//                              interfaceStyle == CTDModalInterfaceStyle ? 'M' : 'Q',
//                              (unsigned long)trialIndex];
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD

- (void)setDuration:(__unused NSTimeInterval)stepDuration
      forStepNumber:(__unused NSUInteger)stepNumber
{

}

- (NSTimeInterval)trialDuration
{
    return 0;
}

@end
