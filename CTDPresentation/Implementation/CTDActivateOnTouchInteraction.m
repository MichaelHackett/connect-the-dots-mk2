// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDActivateOnTouchInteraction.h"

#import "CTDTargetSpace.h"
#import "CTDTargetView.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDActivateOnTouchInteraction
{
    id<CTDTargetSpace> _targetSpace;
    id<CTDTargetView> _selectedTarget;
}

#pragma mark - Initialization

- (instancetype)initWithTargetSpace:(id<CTDTargetSpace>)targetSpace
               initialTouchPosition:(CTDPoint*)initialPosition
{
    self = [super init];
    if (self) {
        _targetSpace = targetSpace;
        _selectedTarget = [targetSpace targetAtLocation:initialPosition];
        if (_selectedTarget) {
            [_selectedTarget showSelectionIndicator];
        }
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD


#pragma mark - CTDTouchTracker protocol

- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    id<CTDTargetView> hitTarget = [_targetSpace targetAtLocation:newPosition];
    if (hitTarget != _selectedTarget) {
        if (_selectedTarget) {
            [_selectedTarget hideSelectionIndicator];
        }
        _selectedTarget = hitTarget;
        [hitTarget showSelectionIndicator];
    }
}

- (void)touchDidEnd
{
    if (_selectedTarget) {
        [_selectedTarget hideSelectionIndicator];
    }
}

- (void)touchWasCancelled
{
    if (_selectedTarget) {
        [_selectedTarget hideSelectionIndicator];
    }
}

@end
