// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDTargetTouchDetector.h"

#import "CTDTouchMapper.h"
#import "CTDConnectionTouchInteraction.h"



@implementation CTDTargetTouchDetector
{
    __weak id<CTDTargetContainerView> _targetContainerView;
    id<CTDTouchMapper> _targetTouchMapper;
}

#pragma mark - Initialization

- (instancetype)initWithTargetContainerView:(id<CTDTargetContainerView>)targetContainerView
                          targetTouchMapper:(id<CTDTouchMapper>)targetTouchMapper
{
    self = [super init];
    if (self) {
        _targetContainerView = targetContainerView;
        _targetTouchMapper = targetTouchMapper;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark - CTDTouchResponder protocol

- (id<CTDTouchTracker>)trackerForTouchStartingAt:(CTDPoint*)initialPosition
{
    return [[CTDConnectionTouchInteraction alloc]
            initWithTargetContainerView:_targetContainerView
                      targetTouchMapper:_targetTouchMapper
                   initialTouchPosition:initialPosition];
}

@end
