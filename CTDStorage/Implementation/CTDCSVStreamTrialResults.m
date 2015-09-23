// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDCSVStreamTrialResults.h"

#import "CTDStreamWriter.h"




@implementation CTDCSVStreamTrialBlockResults
{
    CTDStreamWriter* _outputStreamWriter;
    NSUInteger _participantId;
    CTDHand    _preferredHand;
    CTDInterfaceStyle _interfaceStyle;
}

- (instancetype)initWithParticipantId:(NSUInteger)participantId
                        preferredHand:(CTDHand)preferredHand
                       interfaceStyle:(CTDInterfaceStyle)interfaceStyle
                   outputStreamWriter:(CTDStreamWriter*)outputStreamWriter
{
    self = [super init];
    if (self)
    {
        NSAssert(outputStreamWriter, @"Must supply a non-nil CTDStreamWriter");

        _outputStreamWriter = outputStreamWriter;
        _participantId = participantId;
        _preferredHand = preferredHand;
        _interfaceStyle = interfaceStyle;
    }
    return self;
}

- (void)setDuration:(NSTimeInterval)trialDuration
     forTrialNumber:(NSUInteger)trialNumber
         sequenceId:(NSUInteger)sequenceId
{
    NSAssert(_outputStreamWriter, @"New trial result sent after results finalized.");

    NSString* line = [NSString stringWithFormat:@"%lu, %c, %c, %lu, %lu, %.2f\n",
                      (unsigned long)_participantId,
                      _preferredHand == CTDLeftHand ? 'L' : 'R',
                      _interfaceStyle == CTDModalInterfaceStyle ? 'M': 'Q',
                      (unsigned long)trialNumber,
                      (unsigned long)sequenceId,
                      (double)trialDuration];

    [_outputStreamWriter appendString:line];
}

- (void)finalizeResults
{
    [_outputStreamWriter closeStream];
    _outputStreamWriter = nil;
}

@end





@implementation CTDCSVStreamTrialResults
{
    CTDStreamWriter* _outputStreamWriter;
    NSUInteger _participantId;
    CTDHand    _preferredHand;
    CTDInterfaceStyle _interfaceStyle;
    NSUInteger _trialNumber;
    NSUInteger _sequenceId;
}

- (instancetype)initWithParticipantId:(NSUInteger)participantId
                        preferredHand:(CTDHand)preferredHand
                       interfaceStyle:(CTDInterfaceStyle)interfaceStyle
                          trialNumber:(NSUInteger)trialNumber
                           sequenceId:(NSUInteger)sequenceId
                   outputStreamWriter:(CTDStreamWriter*)outputStreamWriter
{
    self = [super init];
    if (self)
    {
        _outputStreamWriter = outputStreamWriter;
        _participantId = participantId;
        _preferredHand = preferredHand;
        _interfaceStyle = interfaceStyle;
        _trialNumber = trialNumber;
        _sequenceId = sequenceId;
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD

- (void)setDuration:(NSTimeInterval)stepDuration
      forStepNumber:(NSUInteger)stepNumber
{
    NSAssert(_outputStreamWriter, @"New trial step result sent after results finalized.");

    [super setDuration:stepDuration forStepNumber:stepNumber];

    NSString* line = [NSString stringWithFormat:@"%lu, %c, %c, %lu, %lu, %lu, %.2f\n",
                      (unsigned long)_participantId,
                      _preferredHand == CTDLeftHand ? 'L' : 'R',
                      _interfaceStyle == CTDModalInterfaceStyle ? 'M': 'Q',
                      (unsigned long)_trialNumber,
                      (unsigned long)_sequenceId,
                      (unsigned long)stepNumber,
                      (double)stepDuration];

    [_outputStreamWriter appendString:line];
}

- (void)finalizeResults
{
    [_outputStreamWriter closeStream];
    _outputStreamWriter = nil;
}

@end
