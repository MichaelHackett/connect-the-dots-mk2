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
#import "CTDModel/CTDTarget.h"
#import "CTDModel/CTDTargetColor.h"
#import "CTDUtility/CTDPoint.h"



// Macro for defining sample data
#define target(COLOR,X,Y) [[CTDTarget alloc] initWithColor:COLOR position:[[CTDPoint alloc] initWithX:X y:Y]]



@implementation CTDApplication
{
    CTDTargetSetPresenter* _currentPresenter;
    NSArray* _targetList;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentPresenter = nil;
        _targetList = @[
            target(CTDTargetColor_Green, 100, 170),
            target(CTDTargetColor_Red, 600, 400),
            target(CTDTargetColor_Blue, 250, 650)
        ];
    }
    return self;
}

- (void)runTrialWithRenderer:(id<CTDTrialRenderer>)trialRenderer
                colorCellMap:(NSDictionary*)colorCellMap
            touchInputSource:(id<CTDTouchInputSource>)touchInputSource
{
    _currentPresenter = [[CTDTargetSetPresenter alloc]
                         initWithTargetList:_targetList
                              trialRenderer:trialRenderer];

    CTDColorCellGroup* colorCellGroup =
        [[CTDColorCellGroup alloc]
         initWithDefaultColor:CTDTargetColor_White
            selectedColorSink:nil];

    CTDListOrderTouchMapper* colorCellsTouchMapper =
        [[CTDListOrderTouchMapper alloc] init];

    // TODO: reduce repetition in this section

    id<CTDColorCellRenderer, CTDTouchable> redColorCellRenderer =
        [colorCellMap objectForKey:@(CTDPaletteColor_RedTarget)];
    id<CTDColorCellRenderer, CTDTouchable> greenColorCellRenderer =
        [colorCellMap objectForKey:@(CTDPaletteColor_GreenTarget)];
    id<CTDColorCellRenderer, CTDTouchable> blueColorCellRenderer =
        [colorCellMap objectForKey:@(CTDPaletteColor_BlueTarget)];

    [colorCellsTouchMapper mapTouchable:redColorCellRenderer
                           toActuator:[colorCellGroup addCellForColor:CTDTargetColor_Red
                                                         withRenderer:redColorCellRenderer]];
    [colorCellsTouchMapper mapTouchable:greenColorCellRenderer
                           toActuator:[colorCellGroup addCellForColor:CTDTargetColor_Green
                                                         withRenderer:greenColorCellRenderer]];
    [colorCellsTouchMapper mapTouchable:blueColorCellRenderer
                           toActuator:[colorCellGroup addCellForColor:CTDTargetColor_Blue
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
