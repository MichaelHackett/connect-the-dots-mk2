// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDBlockExecutor.h"



@implementation CTDBlockExecutor
{
    CTDBlockExecutorVoidBlock _block;
}

- (instancetype)initWithBlock:(CTDBlockExecutorVoidBlock)block
{
    self = [super init];
    if (self)
    {
        _block = [block copy];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (void)execute
{
    _block();
}

@end
