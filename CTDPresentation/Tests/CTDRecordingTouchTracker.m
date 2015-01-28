// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingTouchTracker.h"

#import "CTDTestHelpers/CTDMessageList.h"
#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDRecordingTouchTracker
{
    CTDMessageList* _messagesReceived;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastTouchPosition = nil;
        _messagesReceived = [[CTDMessageList alloc] init];
    }
    return self;
}

- (void)reset
{
    _lastTouchPosition = nil;
    [_messagesReceived reset];
}

- (CTDMethodSelector*)lastMessage
{
    return [_messagesReceived lastMessage];
}

- (BOOL)hasReceivedMessage:(SEL)selector
{
    return [_messagesReceived includesMessageWithSelector:selector];

}

- (NSUInteger)countOfTrackerMessagesReceived
{
    return [[_messagesReceived indexesOfMessagesWithSelector:@selector(touchDidMoveTo:)] count]
         + [[_messagesReceived indexesOfMessagesWithSelector:@selector(touchDidEnd)] count]
         + [[_messagesReceived indexesOfMessagesWithSelector:@selector(touchWasCancelled)] count];
}



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    _lastTouchPosition = [newPosition copy];
    [_messagesReceived addMessageWithSelector:_cmd];
}

- (void)touchDidEnd
{
    [_messagesReceived addMessageWithSelector:_cmd];
}

- (void)touchWasCancelled
{
    [_messagesReceived addMessageWithSelector:_cmd];
}

@end
