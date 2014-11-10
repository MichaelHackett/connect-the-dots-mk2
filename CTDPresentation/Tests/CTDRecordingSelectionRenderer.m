// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingSelectionRenderer.h"



@implementation CTDRecordingSelectionRenderer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selected = NO;
    }
    return self;
}

- (void)showSelectionIndicator { _selected = YES; }
- (void)hideSelectionIndicator { _selected = NO; }

@end
