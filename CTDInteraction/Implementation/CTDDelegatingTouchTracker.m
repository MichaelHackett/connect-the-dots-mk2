// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDDelegatingTouchTracker.h"


@implementation CTDDelegatingTouchTracker
{
    id<CTDTouchTracker> _delegateTracker;
}

- (instancetype)initWithInitialDelegate:(id<CTDTouchTracker>)delegateTracker
{
    self = [super init];
    if (self) {
        _delegateTracker = delegateTracker;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithInitialDelegate:nil];
}

- (void)changeDelegateTo:(id<CTDTouchTracker>)newDelegate
{
    _delegateTracker = newDelegate;
}



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    if ([_delegateTracker respondsToSelector:@selector(touchDidMoveTo:)]) {
        [_delegateTracker touchDidMoveTo:newPosition];
    }
}

- (void)touchDidEnd
{
    if ([_delegateTracker respondsToSelector:@selector(touchDidEnd)]) {
        [_delegateTracker touchDidEnd];
    }
}

- (void)touchWasCancelled
{
    if ([_delegateTracker respondsToSelector:@selector(touchWasCancelled)]) {
        [_delegateTracker touchWasCancelled];
    }
}

@end
