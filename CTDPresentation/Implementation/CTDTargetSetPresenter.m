// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTargetSetPresenter.h"

#import "CTDListOrderTouchMapper.h"
#import "CTDTargetRenderer.h"
#import "CTDTouchMapper.h"
#import "CTDTrialRenderer.h"
#import "CTDUtility/CTDPoint.h"



// ExerciseRunner (eventually), but just TargetSetPresenter for now?

@implementation CTDTargetSetPresenter
{
    NSArray* _targetViews;
    CTDListOrderTouchMapper* _targetsTouchMapper;
}

- (instancetype)initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer;
{
    self = [super init];
    if (self) {
        NSMutableArray* targetViews = [[NSMutableArray alloc] init];
        [targetViews addObject:
            [trialRenderer newTargetViewCenteredAt:[CTDPoint x:100 y:400]]];
        [targetViews addObject:
            [trialRenderer newTargetViewCenteredAt:[CTDPoint x:600 y:150]]];
        [targetViews addObject:
            [trialRenderer newTargetViewCenteredAt:[CTDPoint x:400 y:550]]];
        _targetViews = [targetViews copy];
        _targetsTouchMapper = [[CTDListOrderTouchMapper alloc] init];
        for (id<CTDTouchable> targetView in targetViews) {
            [_targetsTouchMapper mapTouchable:targetView
                                   toActuator:targetView]; // TODO: Change to some PM obj
        }
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD

- (id<CTDTouchMapper>)targetsTouchMapper
{
    return _targetsTouchMapper;
}

@end
