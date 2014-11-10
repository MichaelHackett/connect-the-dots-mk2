// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingTouchTracker.h"

#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDRecordingTouchTracker
{
    NSMutableArray* _messagesReceived; // CTDMethodSelectors
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastTouchPosition = nil;
        _messagesReceived = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray*)messagesReceived
{
    return [_messagesReceived copy];
}



#pragma mark - CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    _lastTouchPosition = [newPosition copy];
    [_messagesReceived addObject:[[CTDMethodSelector alloc]
                                  initWithRawSelector:@selector(touchDidMoveTo:)]];
}

- (void)touchDidEnd
{
    [_messagesReceived addObject:[[CTDMethodSelector alloc]
                                  initWithRawSelector:@selector(touchDidEnd)]];
}

- (void)touchWasCancelled
{
    [_messagesReceived addObject:[[CTDMethodSelector alloc]
                                  initWithRawSelector:@selector(touchWasCancelled)]];
}

@end
