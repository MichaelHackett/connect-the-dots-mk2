// CTDTestSpy:
//    Base for hand-rolled test spies. Provides the basic message recording
//    functionality that can be used for verification in test code.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDMessageList.h"


// messagesReceivedThatMatch:(SEL)selector -- return list (array, iterator?)
@protocol CTDTestSpy
- (void)recordMessageWithSelector:(SEL)selector;
- (NSUInteger)countOfMessagesReceivedWithSelector:(SEL)selector;  // invocation?
- (BOOL)hasReceivedMessageWithSelector:(SEL)selector;
- (void)reset;
- (NSArray*)messagesReceivedThatMatch:(CTDMessageFilterBlock)filterBlock;
@end


@interface CTDTestSpy : NSObject <CTDTestSpy>
@end
