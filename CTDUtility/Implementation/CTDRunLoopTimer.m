// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDRunLoopTimer.h"
#import "CTDBlockExecutor.h"



@implementation CTDRunLoopTimer
{
    NSTimer* _timer;
}

- (instancetype)initWithDuration:(NSTimeInterval)timeInterval
                    onExpiration:(void (^)(void))timerExpirationBlock
{
    self = [super init];
    if (self)
    {
        // NSTimer retains the target, so we don't need to keep a ref to the block executor.
        CTDBlockExecutor* executor = [[CTDBlockExecutor alloc]
                                      initWithBlock:timerExpirationBlock];
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                  target:executor
                                                selector:@selector(execute)
                                                userInfo:nil
                                                 repeats:NO];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (void)invalidate
{
    [_timer invalidate];
}

@end
