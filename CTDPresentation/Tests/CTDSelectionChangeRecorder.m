// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectionChangeRecorder.h"

#import "CTDTestHelpers/CTDMessageList.h"
#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDSelectionChangeRecorder
{
    CTDMessageList* _messagesReceived;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selected = NO;
        _messagesReceived = [[CTDMessageList alloc] init];
    }
    return self;
}

- (void)reset
{
    [_messagesReceived reset];
}

- (NSArray*)messagesReceived
{
    return [_messagesReceived messageSelectors];
}



#pragma mark CTDSelectable protocol


- (void)select
{
    _selected = YES;
    [_messagesReceived addMessageWithSelector:_cmd];
}

- (void)deselect
{
    _selected = NO;
    [_messagesReceived addMessageWithSelector:_cmd];
}

@end
