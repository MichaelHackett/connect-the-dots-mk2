// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDListOrderTouchMapper.h"
#import "CTDTargetSetPresenter.h"
#import "CTDTrialSceneTouchRouter.h"
#import "CTDTouchResponder.h"



@implementation CTDApplication
{
    CTDTargetSetPresenter* _currentPresenter;
}

- (void)runTrialWithRenderer:(id<CTDTrialRenderer>)trialRenderer
                colorCellMap:(NSDictionary*)colorCellMap
            touchInputSource:(id<CTDTouchInputSource>)touchInputSource
{
    _currentPresenter = [[CTDTargetSetPresenter alloc]
                         initWithTrialRenderer:trialRenderer];

    id<CTDTouchMapper> colorButtonsTouchMapper =
        [CTDListOrderTouchMapper mapperWithTouchables:[colorCellMap allValues]];

    // TODO: Roll touch router into scene presenter? (It already knows about touch mapping.)
    [touchInputSource addTouchResponder:
        [[CTDTrialSceneTouchRouter alloc]
         initWithTrialRenderer:trialRenderer
         targetsTouchMapper:[_currentPresenter targetsTouchMapper]
         colorButtonsTouchMapper:colorButtonsTouchMapper]];
}

@end
