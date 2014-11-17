// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingTouchTracker.h"

#import "CTDMessageRecorder.h"
#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDRecordingTouchTracker
{
    CTDMessageRecorder* _messageRecorder;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastTouchPosition = nil;
        _messageRecorder = [[CTDMessageRecorder alloc] init];
    }
    return self;
}

- (void)reset
{
    _lastTouchPosition = nil;
    [_messageRecorder reset];
}

- (CTDMethodSelector*)lastMessage
{
    return [_messageRecorder lastMessage];
}

- (BOOL)hasReceivedMessage:(SEL)selector
{
    return [_messageRecorder hasReceivedMessageWithSelector:selector];

}

- (NSUInteger)countOfTrackerMessagesReceived
{
    return [_messageRecorder countOfMessagesReceivedWithSelector:@selector(touchDidMoveTo:)]
         + [_messageRecorder countOfMessagesReceivedWithSelector:@selector(touchDidEnd)]
         + [_messageRecorder countOfMessagesReceivedWithSelector:@selector(touchWasCancelled)];
}



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    _lastTouchPosition = [newPosition copy];
    [_messageRecorder addMessageWithSelector:@selector(touchDidMoveTo:)];
}

- (void)touchDidEnd
{
    [_messageRecorder addMessageWithSelector:@selector(touchDidEnd)];
}

- (void)touchWasCancelled
{
    [_messageRecorder addMessageWithSelector:@selector(touchWasCancelled)];
}

@end
