// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingTouchTracker.h"

#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDRecordingTouchTracker

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastTouchPosition = nil;
        _lastTrackerMessage = nil;
    }
    return self;
}

- (void)reset
{
    [super reset];
    _lastTouchPosition = nil;
    _lastTrackerMessage = nil;
}

- (NSUInteger)countOfTrackerMessagesReceived
{
    return [self countOfMessagesReceivedWithSelector:@selector(touchDidMoveTo:)]
         + [self countOfMessagesReceivedWithSelector:@selector(touchDidEnd)]
         + [self countOfMessagesReceivedWithSelector:@selector(touchWasCancelled)];
}



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    _lastTouchPosition = [newPosition copy];
    _lastTrackerMessage = [[CTDMethodSelector alloc] initWithRawSelector:_cmd];
    [self recordMessageWithSelector:_cmd];
}

- (void)touchDidEnd
{
    _lastTrackerMessage = [[CTDMethodSelector alloc] initWithRawSelector:_cmd];
    [self recordMessageWithSelector:_cmd];
}

- (void)touchWasCancelled
{
    _lastTrackerMessage = [[CTDMethodSelector alloc] initWithRawSelector:_cmd];
    [self recordMessageWithSelector:_cmd];
}

@end
