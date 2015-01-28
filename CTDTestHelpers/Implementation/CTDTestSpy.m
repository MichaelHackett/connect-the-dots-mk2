// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTestSpy.h"

#import "CTDMessageRecorder.h"



@implementation CTDTestSpy
{
    CTDMessageRecorder* _receivedMessages;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _receivedMessages = [[CTDMessageRecorder alloc] init];
    }
    return self;
}

- (void)reset
{
    [_receivedMessages reset];
}

- (void)recordMessageWithSelector:(SEL)selector
{
    [_receivedMessages addMessageWithSelector:selector];
}

//- (CTDMethodSelector*)lastMessage
//{
//    return [_messageRecorder lastMessage];
//    return nil;
//}

- (NSUInteger)countOfMessagesReceivedThatMatch:(SEL)selector
{
    return [_receivedMessages countOfMessagesReceivedWithSelector:selector];
}

@end
