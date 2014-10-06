// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDTargetTouchDetector.h"

#import "CTDConnectionTouchInteraction.h"



@implementation CTDTargetTouchDetector
{
    __weak id<CTDTargetContainerView> _targetContainerView;
    id<CTDTargetSpace> _targetSpace;
}

#pragma mark - Initialization

- (instancetype)initWithTargetContainerView:(id<CTDTargetContainerView>)targetContainerView
                                targetSpace:(id<CTDTargetSpace>)targetSpace
{
    self = [super init];
    if (self) {
        _targetContainerView = targetContainerView;
        _targetSpace = targetSpace;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark - CTDTouchResponder protocol

- (id<CTDTouchTracker>)trackerForTouchStartingAt:(CTDPoint*)initialPosition
{
    return [[CTDConnectionTouchInteraction alloc]
            initWithTargetContainerView:_targetContainerView
                            targetSpace:_targetSpace
                   initialTouchPosition:initialPosition];
}

@end
