// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTargetSetPresenter.h"

#import "CTDColorPalette.h"
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
            [trialRenderer newTargetViewCenteredAt:[CTDPoint x:100 y:400]
                                  withInitialColor:CTDPALETTE_GREEN_TARGET]];
        [targetViews addObject:
            [trialRenderer newTargetViewCenteredAt:[CTDPoint x:600 y:150]
                                  withInitialColor:CTDPALETTE_RED_TARGET]];
        [targetViews addObject:
            [trialRenderer newTargetViewCenteredAt:[CTDPoint x:400 y:550]
                                  withInitialColor:CTDPALETTE_BLUE_TARGET]];

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
