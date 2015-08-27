// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDFakeTouchTracker.h"

#import "CTDUtility/CTDPoint.h"



CTDFakeTouchTrackerState const CTDTouchTrackerStateActive = @"ACTIVE";
CTDFakeTouchTrackerState const CTDTouchTrackerStateEnded = @"ENDED";
CTDFakeTouchTrackerState const CTDTouchTrackerStateCancelled = @"CANCELLED";




@implementation CTDFakeTouchTracker

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _lastTouchPosition = nil;
        _state = CTDTouchTrackerStateActive;
    }
    return self;
}

- (void)reset
{
    _lastTouchPosition = nil;
    _state = CTDTouchTrackerStateActive;
}



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    NSAssert(_state == CTDTouchTrackerStateActive,
             @"Touch tracker received 'moved' message when already ended or cancelled");
    _lastTouchPosition = [newPosition copy];
}

- (void)touchDidEnd
{
    NSAssert(_state == CTDTouchTrackerStateActive,
             @"Touch tracker received 'ended' message when already ended or cancelled");
    _state = CTDTouchTrackerStateEnded;
}

- (void)touchWasCancelled
{
    NSAssert(_state == CTDTouchTrackerStateActive,
             @"Touch tracker received 'cancelled' message when already ended or cancelled");
    _state = CTDTouchTrackerStateCancelled;
}

@end
