// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectOnTouchInteraction.h"

#import "CTDTargetView.h"
#import "CTDTouchMapper.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDSelectOnTouchInteraction
{
    id<CTDTouchMapper> _targetTouchMapper;
    id<CTDTargetView> _selectedTarget;
}



#pragma mark - Initialization


- (instancetype)initWithTargetTouchMapper:(id<CTDTouchMapper>)targetTouchMapper
                     initialTouchPosition:(CTDPoint*)initialPosition
{
    self = [super init];
    if (self) {
        _targetTouchMapper = targetTouchMapper;
        _selectedTarget = [_targetTouchMapper elementAtTouchLocation:initialPosition];
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
    id<CTDTargetView> hitTarget = [_targetTouchMapper elementAtTouchLocation:newPosition];
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
