// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchTrackerFactory.h"



@implementation CTDTouchTrackerFactory
{
    CTDTouchTrackerFactoryBlock _trackerFactoryBlock;
}

- (instancetype)initWithTouchTrackerFactoryBlock:
                    (CTDTouchTrackerFactoryBlock)trackerFactoryBlock
{
    self = [super init];
    if (self) {
        _trackerFactoryBlock = [trackerFactoryBlock copy];
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD

- (id<CTDTouchTracker>)trackerForTouchStartingAt:(CTDPoint*)initialPosition
{
    return _trackerFactoryBlock(initialPosition);
}

@end
