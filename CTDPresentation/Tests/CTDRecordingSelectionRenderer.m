// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingSelectionRenderer.h"

#import "CTDTestHelpers/CTDMessageList.h"



@implementation CTDRecordingSelectionRenderer
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



#pragma mark CTDSelectionRenderer protocol


- (void)showSelectionIndicator
{
    _selected = YES;
    [_messagesReceived addMessageWithSelector:_cmd];
}

- (void)hideSelectionIndicator
{
    _selected = NO;
    [_messagesReceived addMessageWithSelector:_cmd];
}

@end
