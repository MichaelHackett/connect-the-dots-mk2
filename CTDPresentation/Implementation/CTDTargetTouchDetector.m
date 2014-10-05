// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDTargetTouchDetector.h"

#import "CTDTargetSpace.h"
#import "CTDTargetView.h"
#import "CTDUtility/CTDPoint.h"



@interface CTDActivateOnTouchInteractor : NSObject <CTDTouchTracker>
CTD_NO_DEFAULT_INIT
@end

@implementation CTDActivateOnTouchInteractor
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

- (id<CTDTouchTracker>)trackerForTouchStartingAt:(__unused CTDPoint*)initialPosition
{
    return [[CTDActivateOnTouchInteractor alloc]
            initWithTargetSpace:_targetSpace
            initialTouchPosition:initialPosition];
}

@end
