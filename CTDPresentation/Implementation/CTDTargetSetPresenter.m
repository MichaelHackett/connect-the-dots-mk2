// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTargetSetPresenter.h"

#import "CTDTargetView.h"
#import "CTDUtility/CTDPoint.h"


// ExerciseRunner (eventually), but just TargetSetPresenter for now?

@implementation CTDTargetSetPresenter
{
    NSArray* _targetViews;
}

- (instancetype)
      initWithTargetViewRenderer:(id<CTDTargetViewRenderer>)targetViewRenderer
{
    self = [super init];
    if (self) {
        NSMutableArray* targetView = [[NSMutableArray alloc] init];
        id<CTDTargetView> target1 =
            [targetViewRenderer newTargetViewCenteredAt:[CTDPoint x:100 y:400]];
        id<CTDTargetView> target2 =
            [targetViewRenderer newTargetViewCenteredAt:[CTDPoint x:600 y:150]];
        id<CTDTargetView> target3 =
            [targetViewRenderer newTargetViewCenteredAt:[CTDPoint x:400 y:550]];
        [targetView addObject:target1];
        [targetView addObject:target2];
        [targetView addObject:target3];

        _targetViews = [targetView copy];
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD

- (id<CTDTargetView>)targetAtLocation:(CTDPoint*)location;
{
    for (id<CTDTargetView> targetView in _targetViews) {
        if ([targetView containsPoint:location]) {
            return targetView;
        }
    }
    return nil;
}

@end
