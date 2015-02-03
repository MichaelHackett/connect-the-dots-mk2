// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDMessageList.h"

#import "CTDUtility/CTDMethodSelector.h"



@implementation CTDMessageList
{
    NSMutableArray* _messageSelectors; // CTDMethodSelectors
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _messageSelectors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray*)messageSelectors
{
    return [_messageSelectors copy];
}

- (void)reset
{
    [_messageSelectors removeAllObjects];
}

- (void)addMessageWithSelector:(SEL)selector
{
    [_messageSelectors addObject:[[CTDMethodSelector alloc]
                                  initWithRawSelector:selector]];
}

- (BOOL)includesMessageWithSelector:(SEL)selector
{
    return [_messageSelectors containsObject:[[CTDMethodSelector alloc]
                                              initWithRawSelector:selector]];
}

- (CTDMethodSelector*)lastMessage
{
    return [_messageSelectors lastObject];
}

- (NSIndexSet*)indexesOfMessagesWithSelector:(SEL)selector
{
    return [_messageSelectors indexesOfObjectsPassingTest:
        ^BOOL(id obj, __unused NSUInteger index, __unused BOOL* stop)
        {
            return ((CTDMethodSelector*)obj).rawSelector == selector;
        }];
}

- (NSArray*)messagesMatching:(CTDMessageFilterBlock)filterBlock
{
    return [_messageSelectors objectsAtIndexes:
        [_messageSelectors indexesOfObjectsPassingTest:
            ^BOOL(id message, __unused NSUInteger index, __unused BOOL* stop) {
                return filterBlock(message);
            }
        ]
    ];
}

@end
