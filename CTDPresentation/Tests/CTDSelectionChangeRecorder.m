// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectionChangeRecorder.h"

#import "CTDMessageRecorder.h"
#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDSelectionChangeRecorder
{
    CTDMessageRecorder* _messageRecorder;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selected = NO;
        _messageRecorder = [[CTDMessageRecorder alloc] init];
    }
    return self;
}

- (void)reset
{
    [_messageRecorder reset];
}

- (NSArray*)messagesReceived
{
    return [_messageRecorder messagesReceived];
}



#pragma mark CTDSelectable protocol


- (void)select
{
    _selected = YES;
    [_messageRecorder addMessageWithSelector:@selector(select)];
}

- (void)deselect
{
    _selected = NO;
    [_messageRecorder addMessageWithSelector:@selector(deselect)];
}

@end
