// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDRecordingColorCellRenderer.h"


@implementation CTDRecordingColorCellRenderer


#pragma mark CTDSelectionRenderer protocol


- (void)showHighlightIndicator
{
    [self recordMessageWithSelector:_cmd];
}

- (void)hideHighlightIndicator
{
    [self recordMessageWithSelector:_cmd];
}

@end
