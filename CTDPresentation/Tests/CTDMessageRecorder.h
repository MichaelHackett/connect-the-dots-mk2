// CTDMessageRecorder:
//     Records a list of object messages and provides some tools for searching
//     within the list. (At the moment, the class only records the selector of
//     a message, not the arguments, but that could be extended --- say, by
//     accepting NSInvocations or arrays of arguments --- if there is need.)
//
// Copyright 2014 Michael Hackett. All rights reserved.

@class CTDMethodSelector;



@interface CTDMessageRecorder : NSObject

@property (copy, readonly, nonatomic) NSArray* messagesReceived;

- (void)reset;
- (void)addMessageWithSelector:(SEL)selector;
- (BOOL)hasReceivedMessageWithSelector:(SEL)selector;
- (CTDMethodSelector*)lastMessage;
- (NSUInteger)countOfMessagesReceivedWithSelector:(SEL)selector;

@end
