// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDListOrderTouchMapper.h"
#import "CTDSelectOnTapInteraction.h"
#import "CTDSelectOnTouchInteraction.h"
#import "CTDTargetSetPresenter.h"
#import "CTDTrialSceneTouchRouter.h"
#import "CTDTouchResponder.h"
#import "CTDTouchTrackerFactory.h"



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

    id<CTDTouchMapper> colorCellsTouchMapper =
        [CTDListOrderTouchMapper mapperWithTouchables:[colorCellMap allValues]];
    id<CTDTouchResponder> colorCellsTouchResponder =
        [[CTDTouchTrackerFactory alloc]
         initWithTouchTrackerFactoryBlock:
             ^id<CTDTouchTracker>(CTDPoint* initialPosition)
             {
//                 return [[CTDSelectOnTouchInteraction alloc]
                 return [[CTDSelectOnTapInteraction alloc]
                         initWithTouchMapper:colorCellsTouchMapper
                         initialTouchPosition:initialPosition];
             }];

    // I don't really like the splitting of input handling between here and the
    // TouchRouter class. The use of things like CTDSelectOnTouchInteraction
    // should be specified in the same place as the delegation/redirection
    // laid out in the touch router.

    // TODO: Roll touch router into scene presenter? (It already knows about touch mapping.)
    [touchInputSource addTouchResponder:
        [[CTDTrialSceneTouchRouter alloc]
         initWithTrialRenderer:trialRenderer
         targetsTouchMapper:[_currentPresenter targetsTouchMapper]
         colorCellsTouchResponder:colorCellsTouchResponder]];
}

@end
