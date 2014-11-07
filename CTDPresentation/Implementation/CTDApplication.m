// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDTargetSetPresenter.h"
#import "CTDTrialSceneTouchRouter.h"
#import "CTDTouchResponder.h"



@implementation CTDApplication
{
    CTDTargetSetPresenter* _currentPresenter;
}

- (void)runTrialWithRenderer:(id<CTDTrialRenderer>)trialRenderer
            touchInputSource:(id<CTDTouchInputSource>)touchInputSource
{
    _currentPresenter = [[CTDTargetSetPresenter alloc]
                         initWithTrialRenderer:trialRenderer];

    // TODO: Roll touch router into scene presenter? (It already knows about touch mapping.)
    [touchInputSource addTouchResponder:
        [[CTDTrialSceneTouchRouter alloc]
         initWithTrialRenderer:trialRenderer
            targetsTouchMapper:[_currentPresenter targetsTouchMapper]]];
}

@end
