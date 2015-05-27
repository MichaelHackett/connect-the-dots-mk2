// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDInteraction/CTDListOrderTouchMapper.h"
#import "CTDInteraction/CTDSelectOnTapInteraction.h"
#import "CTDInteraction/CTDSelectOnTouchInteraction.h"
#import "CTDInteraction/CTDTouchTrackerFactory.h"
#import "CTDInteraction/CTDTrialSceneTouchRouter.h"
#import "CTDModel/CTDDot.h"
#import "CTDModel/CTDDotColor.h"
#import "CTDPresentation/CTDColorCellGroup.h"
#import "CTDPresentation/CTDColorPalette.h"
#import "CTDPresentation/CTDDotSetPresenter.h"
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

- (id<CTDTouchResponder>)
      newTrialPresenterWithRenderer:(id<CTDTrialRenderer>)trialRenderer
                colorCellMap:(NSDictionary*)colorCellMap
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

    id<CTDColorCellRenderer, CTDTouchable> colorCell1Renderer =
        [colorCellMap objectForKey:CTDPaletteColor_DotType1];
    id<CTDColorCellRenderer, CTDTouchable> colorCell2Renderer =
        [colorCellMap objectForKey:CTDPaletteColor_DotType2];
    id<CTDColorCellRenderer, CTDTouchable> colorCell3Renderer =
        [colorCellMap objectForKey:CTDPaletteColor_DotType3];

    [colorCellsTouchMapper mapTouchable:colorCell1Renderer
                           toActuator:[colorCellGroup addCellForColor:CTDDotColor_Red
                                                         withRenderer:colorCell1Renderer]];
    [colorCellsTouchMapper mapTouchable:colorCell2Renderer
                           toActuator:[colorCellGroup addCellForColor:CTDDotColor_Green
                                                         withRenderer:colorCell2Renderer]];
    [colorCellsTouchMapper mapTouchable:colorCell3Renderer
                           toActuator:[colorCellGroup addCellForColor:CTDDotColor_Blue
                                                         withRenderer:colorCell3Renderer]];

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
//    [touchInputRouter addTouchResponder:

    return [[CTDTrialSceneTouchRouter alloc]
            initWithTrialRenderer:trialRenderer
            dotsTouchMapper:[_currentPresenter dotsTouchMapper]
            colorCellsTouchResponder:colorCellsTouchResponder];
}

@end
