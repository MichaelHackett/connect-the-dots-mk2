// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTestSpy.h"

#import "CTDMessageList.h"



@implementation CTDTestSpy
{
    CTDMessageList* _receivedMessages;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _receivedMessages = [[CTDMessageList alloc] init];
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

- (NSUInteger)countOfMessagesReceivedWithSelector:(SEL)selector
{
    return [[_receivedMessages indexesOfMessagesWithSelector:selector] count];
}

- (BOOL)hasReceivedMessageWithSelector:(SEL)selector
{
    return [_receivedMessages includesMessageWithSelector:selector];
}

- (NSArray*)messagesReceivedThatMatch:(CTDMessageFilterBlock)filterBlock
{
    return [_receivedMessages messagesMatching:filterBlock];
}

@end
