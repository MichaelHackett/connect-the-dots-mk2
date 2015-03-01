// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDSelectionChangeRecorder.h"

#import "CTDTestHelpers/CTDMessageList.h"
#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDSelectionChangeRecorder

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selected = NO;
    }
    return self;
}

- (NSArray*)selectionMesssagesReceived
{
    return [self messagesReceivedThatMatch:^BOOL(CTDMethodSelector* messageSelector) {
        return [messageSelector isEqualToRawSelector:@selector(select)]
        || [messageSelector isEqualToRawSelector:@selector(deselect)];
    }];
}



#pragma mark CTDSelectable protocol


- (void)select
{
    _selected = YES;
    [self recordMessageWithSelector:_cmd];
}

- (void)deselect
{
    _selected = NO;
    [self recordMessageWithSelector:_cmd];
}

@end
