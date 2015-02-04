// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDRecordingTouchTracker.h"

#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDRecordingTouchTracker

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastTouchPosition = nil;
    }
    return self;
}

- (void)reset
{
    [super reset];
    _lastTouchPosition = nil;
}

- (NSArray*)touchTrackingMesssagesReceived
{
    return [self messagesReceivedThatMatch:^BOOL(CTDMethodSelector* messageSelector) {
        return [messageSelector isEqualToRawSelector:@selector(touchDidMoveTo:)]
        || [messageSelector isEqualToRawSelector:@selector(touchDidEnd)]
        || [messageSelector isEqualToRawSelector:@selector(touchWasCancelled)];
    }];
}



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    _lastTouchPosition = [newPosition copy];
    [self recordMessageWithSelector:_cmd];
}

- (void)touchDidEnd
{
    [self recordMessageWithSelector:_cmd];
}

- (void)touchWasCancelled
{
    [self recordMessageWithSelector:_cmd];
}

@end
