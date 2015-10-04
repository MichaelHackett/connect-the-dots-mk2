// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDCSVStreamTrialResults.h"

#import "CTDStreamWriter.h"
#import "CTDUtility/CTDPoint.h"




@implementation CTDCSVStreamTrialBlockResults
{
    CTDStreamWriter* _outputStreamWriter;
    NSUInteger _participantId;
    CTDHand    _preferredHand;
    CTDInterfaceStyle _interfaceStyle;
    NSMutableArray* _trialDurations;
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
        _trialDurations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setDuration:(NSTimeInterval)trialDuration
     forTrialNumber:(NSUInteger)trialNumber
         sequenceId:(NSUInteger)sequenceId
{
    NSAssert(_outputStreamWriter, @"New trial result sent after results finalized.");

    [_trialDurations addObject:@(trialDuration)];

    NSString* line = [NSString stringWithFormat:@"%lu, %c, %c, %lu, %lu, %.2f\n",
                      (unsigned long)_participantId,
                      _preferredHand == CTDLeftHand ? 'L' : 'R',
                      _interfaceStyle == CTDModalInterfaceStyle ? 'M': 'Q',
                      (unsigned long)trialNumber,
                      (unsigned long)sequenceId,
                      (double)trialDuration];

    [_outputStreamWriter appendString:line];
}

- (NSUInteger)trialCount
{
    return [_trialDurations count];
}

- (NSTimeInterval)totalDuration
{
    __block NSTimeInterval totalDuration = 0;
    [_trialDurations enumerateObjectsUsingBlock:^(NSNumber* trialDuration,
                                                  __unused NSUInteger idx,
                                                  __unused BOOL* stop)
    {
        totalDuration += [trialDuration doubleValue];
    }];

    return totalDuration;
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
        startingDotPosition:(CTDPoint*)startingDotPosition
        endingDotPosition:(CTDPoint*)endingDotPosition
{
    NSAssert(_outputStreamWriter, @"New trial step result sent after results finalized.");

    [super setDuration:stepDuration
           forStepNumber:stepNumber
           startingDotPosition:startingDotPosition
           endingDotPosition:endingDotPosition];

    double dx = startingDotPosition.x - endingDotPosition.x;
    double dy = startingDotPosition.y - endingDotPosition.y;
    double dotDistance = sqrt((dx * dx) + (dy * dy));

    NSString* line = [NSString stringWithFormat:
                      @"%lu, %c, %c, %lu, %lu, %lu, %.0f, %.0f, %.0f, %.0f, %.0f, %.2f\n",
                      (unsigned long)_participantId,
                      _preferredHand == CTDLeftHand ? 'L' : 'R',
                      _interfaceStyle == CTDModalInterfaceStyle ? 'M': 'Q',
                      (unsigned long)_trialNumber,
                      (unsigned long)_sequenceId,
                      (unsigned long)stepNumber,
                      round(startingDotPosition.x),
                      round(startingDotPosition.y),
                      round(endingDotPosition.x),
                      round(endingDotPosition.y),
                      round(dotDistance),
                      (double)stepDuration];

    [_outputStreamWriter appendString:line];
}

- (void)finalizeResults
{
    [_outputStreamWriter closeStream];
    _outputStreamWriter = nil;
}

@end
