// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingSelectionRenderer.h"

#import "CTDMessageRecorder.h"



@implementation CTDRecordingSelectionRenderer
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



#pragma mark CTDSelectionRenderer protocol


- (void)showSelectionIndicator
{
    _selected = YES;
    [_messageRecorder addMessageWithSelector:@selector(showSelectionIndicator)];
}

- (void)hideSelectionIndicator
{
    _selected = NO;
    [_messageRecorder addMessageWithSelector:@selector(hideSelectionIndicator)];
}

@end
