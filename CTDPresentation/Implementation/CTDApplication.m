// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDColorCellGroup.h"
#import "CTDColorPalette.h"
#import "CTDDotSetPresenter.h"
#import "CTDListOrderTouchMapper.h"
#import "CTDSelectOnTapInteraction.h"
#import "CTDSelectOnTouchInteraction.h"
#import "CTDTouchResponder.h"
#import "CTDTouchTrackerFactory.h"
#import "CTDTrialSceneTouchRouter.h"
#import "CTDModel/CTDDot.h"
#import "CTDModel/CTDDotColor.h"
#import "CTDUtility/CTDPoint.h"



// Macro for defining sample data
#define dot(COLOR,X,Y) [[CTDDot alloc] initWithColor:COLOR position:[[CTDPoint alloc] initWithX:X y:Y]]



@implementation CTDApplication
{
    CTDDotSetPresenter* _currentPresenter;
    NSArray* _dotList;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentPresenter = nil;
        _dotList = @[
            dot(CTDDotColor_Green, 100, 170),
            dot(CTDDotColor_Red, 600, 400),
            dot(CTDDotColor_Blue, 250, 650)
        ];
    }
    return self;
}

- (void)runTrialWithRenderer:(id<CTDTrialRenderer>)trialRenderer
                colorCellMap:(NSDictionary*)colorCellMap
            touchInputSource:(id<CTDTouchInputSource>)touchInputSource
{
    _currentPresenter = [[CTDDotSetPresenter alloc]
                         initWithDotList:_dotList
                           trialRenderer:trialRenderer];

    CTDColorCellGroup* colorCellGroup =
        [[CTDColorCellGroup alloc]
         initWithDefaultColor:CTDDotColor_White
            selectedColorSink:nil];

    CTDListOrderTouchMapper* colorCellsTouchMapper =
        [[CTDListOrderTouchMapper alloc] init];

    // TODO: reduce repetition in this section

    id<CTDColorCellRenderer, CTDTouchable> redColorCellRenderer =
        [colorCellMap objectForKey:@(CTDPaletteColor_RedDot)];
    id<CTDColorCellRenderer, CTDTouchable> greenColorCellRenderer =
        [colorCellMap objectForKey:@(CTDPaletteColor_GreenDot)];
    id<CTDColorCellRenderer, CTDTouchable> blueColorCellRenderer =
        [colorCellMap objectForKey:@(CTDPaletteColor_BlueDot)];

    [colorCellsTouchMapper mapTouchable:redColorCellRenderer
                           toActuator:[colorCellGroup addCellForColor:CTDDotColor_Red
                                                         withRenderer:redColorCellRenderer]];
    [colorCellsTouchMapper mapTouchable:greenColorCellRenderer
                           toActuator:[colorCellGroup addCellForColor:CTDDotColor_Green
                                                         withRenderer:greenColorCellRenderer]];
    [colorCellsTouchMapper mapTouchable:blueColorCellRenderer
                           toActuator:[colorCellGroup addCellForColor:CTDDotColor_Blue
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
         dotsTouchMapper:[_currentPresenter dotsTouchMapper]
         colorCellsTouchResponder:colorCellsTouchResponder]];
}

@end
