// CTDTestSpy:
//    Base for hand-rolled test spies. Provides the basic message recording
//    functionality that can be used for verification in test code.
//
// Copyright 2015 Michael Hackett. All rights reserved.


// messagesReceivedThatMatch:(SEL)selector -- return list (array, iterator?)
@protocol CTDTestSpy
- (void)recordMessageWithSelector:(SEL)selector;
- (NSUInteger)countOfMessagesReceivedThatMatch:(SEL)selector;  // invocation?
- (void)reset;
@end


@interface CTDTestSpy : NSObject <CTDTestSpy>
@end
