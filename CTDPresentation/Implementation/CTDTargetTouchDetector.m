// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDTargetTouchDetector.h"

#import "CTDActivateOnTouchInteraction.h"



@implementation CTDTargetTouchDetector
{
    id<CTDTargetSpace> _targetSpace;
}

#pragma mark - Initialization

- (instancetype)initWithTargetSpace:(id<CTDTargetSpace>)targetSpace
{
    self = [super init];
    if (self) {
        _targetSpace = targetSpace;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark - CTDTouchResponder protocol

- (id<CTDTouchTracker>)trackerForTouchStartingAt:(CTDPoint*)initialPosition
{
    return [[CTDActivateOnTouchInteraction alloc]
            initWithTargetSpace:_targetSpace
            initialTouchPosition:initialPosition];
}

@end
