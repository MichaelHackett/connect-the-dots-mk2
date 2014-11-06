// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDTargetSetPresenter.h"
#import "CTDExerciseSceneTouchRouter.h"
#import "CTDTouchResponder.h"



@implementation CTDApplication
{
    CTDTargetSetPresenter* _currentPresenter;
}

- (void)showTargetSetInContainerView:(id<CTDTargetContainerView>)targetContainerView
                withTouchInputSource:(id<CTDTouchInputSource>)touchInputSource
{
    _currentPresenter = [[CTDTargetSetPresenter alloc]
                         initWithTargetContainerView:targetContainerView];

    // TODO: Roll touch router into scene presenter? (It already knows about touch mapping.)
    [touchInputSource addTouchResponder:
        [[CTDExerciseSceneTouchRouter alloc]
         initWithTargetContainerView:targetContainerView
                  targetsTouchMapper:[_currentPresenter targetsTouchMapper]]];
}

@end
