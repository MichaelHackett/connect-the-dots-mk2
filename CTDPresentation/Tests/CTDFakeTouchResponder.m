// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDFakeTouchResponder.h"

#import "CTDUtility/CTDPoint.h"



@implementation CTDFakeTouchResponder
{
    CTDTrackerFactoryBlock _trackerFactoryBlock;
    NSMutableArray* _touchStartingPositions;
}

- (instancetype)initWithTouchTrackerFactoryBlock:
                    (CTDTrackerFactoryBlock)trackerFactoryBlock;
{
    self = [super init];
    if (self) {
        _trackerFactoryBlock = [trackerFactoryBlock copy];
        _touchStartingPositions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (id<CTDTouchTracker>)trackerForTouchStartingAt:(CTDPoint*)initialPosition
{
    [_touchStartingPositions addObject:[initialPosition copy]];
    return _trackerFactoryBlock(initialPosition);
}

- (NSArray*)touchStartingPositions
{
    return [_touchStartingPositions copy];
}

@end
