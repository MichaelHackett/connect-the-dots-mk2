// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDMessageRecorder.h"

#import "CTDUtility/CTDMethodSelector.h"



@implementation CTDMessageRecorder
{
    NSMutableArray* _messagesReceived; // CTDMethodSelectors
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _messagesReceived = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray*)messagesReceived
{
    return [_messagesReceived copy];
}

- (void)reset
{
    [_messagesReceived removeAllObjects];
}

- (void)addMessageWithSelector:(SEL)selector
{
    [_messagesReceived addObject:[[CTDMethodSelector alloc]
                                  initWithRawSelector:selector]];
}

- (BOOL)hasReceivedMessageWithSelector:(SEL)selector
{
    return [_messagesReceived containsObject:[[CTDMethodSelector alloc]
                                              initWithRawSelector:selector]];
}

- (CTDMethodSelector*)lastMessage
{
    return [_messagesReceived lastObject];
}

- (NSUInteger)countOfMessagesReceivedWithSelector:(SEL)selector
{
    return [[_messagesReceived indexesOfObjectsPassingTest:
        ^BOOL(id obj, __unused NSUInteger index, __unused BOOL* stop)
        {
            return ((CTDMethodSelector*)obj).rawSelector == selector;
        }] count];
}

@end
