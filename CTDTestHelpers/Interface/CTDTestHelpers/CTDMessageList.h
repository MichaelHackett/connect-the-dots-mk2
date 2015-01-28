// CTDMessageList:
//     A list of object messages, with some tools for matching items in the
//     list. (At the moment, the class only records the selector of a message,
//     not the arguments, but that could be extended --- say, by accepting
//     NSInvocations or arrays of arguments --- if there is need.)
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

@class CTDMethodSelector;



@interface CTDMessageList : NSObject

@property (copy, readonly, nonatomic) NSArray* messageSelectors;

- (void)reset;
- (void)addMessageWithSelector:(SEL)selector;
- (BOOL)includesMessageWithSelector:(SEL)selector;
- (CTDMethodSelector*)lastMessage;
- (NSIndexSet*)indexesOfMessagesWithSelector:(SEL)selector;

@end
