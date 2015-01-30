// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingSelectionRenderer.h"

#import "CTDTestHelpers/CTDMessageList.h"



@implementation CTDRecordingSelectionRenderer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selected = NO;
    }
    return self;
}



#pragma mark CTDSelectionRenderer protocol


- (void)showSelectionIndicator
{
    _selected = YES;
    [self recordMessageWithSelector:_cmd];
}

- (void)hideSelectionIndicator
{
    _selected = NO;
    [self recordMessageWithSelector:_cmd];
}

@end
