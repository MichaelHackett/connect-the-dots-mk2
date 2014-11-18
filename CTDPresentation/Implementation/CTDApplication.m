// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDColorCellGroup.h"
#import "CTDColorPalette.h"
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

    CTDColorCellGroup* colorCellGroup =
        [[CTDColorCellGroup alloc]
         initWithDefaultColor:CTDTARGETCOLOR_WHITE
            selectedColorSink:nil];

    CTDListOrderTouchMapper* colorCellsTouchMapper =
        [[CTDListOrderTouchMapper alloc] init];

    // TODO: reduce repetition in this section

    id<CTDColorCellRenderer, CTDTouchable> redColorCellRenderer =
        [colorCellMap objectForKey:@(CTDPALETTE_RED_TARGET)];
    id<CTDColorCellRenderer, CTDTouchable> greenColorCellRenderer =
        [colorCellMap objectForKey:@(CTDPALETTE_GREEN_TARGET)];
    id<CTDColorCellRenderer, CTDTouchable> blueColorCellRenderer =
        [colorCellMap objectForKey:@(CTDPALETTE_BLUE_TARGET)];

    [colorCellsTouchMapper mapTouchable:redColorCellRenderer
                           toActuator:[colorCellGroup addCellForColor:CTDTARGETCOLOR_RED
                                                         withRenderer:redColorCellRenderer]];
    [colorCellsTouchMapper mapTouchable:greenColorCellRenderer
                           toActuator:[colorCellGroup addCellForColor:CTDTARGETCOLOR_GREEN
                                                         withRenderer:greenColorCellRenderer]];
    [colorCellsTouchMapper mapTouchable:blueColorCellRenderer
                           toActuator:[colorCellGroup addCellForColor:CTDTARGETCOLOR_BLUE
                                                         withRenderer:blueColorCellRenderer]];

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
