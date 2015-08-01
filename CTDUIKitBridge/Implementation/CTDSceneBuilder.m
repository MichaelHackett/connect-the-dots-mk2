// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDSceneBuilder.h"

#import "CTDActivities/Ports/CTDConnectScene.h"
#import "CTDInteraction/CTDListOrderTouchMapper.h"
#import "CTDInteraction/CTDSelectOnTapInteraction.h"
#import "CTDInteraction/CTDSelectOnTouchInteraction.h"
#import "CTDInteraction/CTDTouchTrackerFactory.h"
#import "CTDInteraction/CTDTrialSceneTouchRouter.h"
#import "CTDPresentation/CTDColorCellGroup.h"
#import "CTDPresentation/CTDPresentation.h"
#import "CTDPresentation/CTDTrialActivityView.h"
#import "CTDPresentation/Ports/CTDSelectionRenderer.h"
#import "CTDUtility/CTDPoint.h"


// Macro for defining sample data
#define dot(COLOR,X,Y) [[CTDDot alloc] initWithColor:COLOR position:[[CTDPoint alloc] initWithX:X y:Y]]


// Merge drawing config into this class (rather than separate class)?
// If config gets loaded from a file eventually, then makes sense to keep it separate.



@implementation CTDSceneBuilder


#pragma mark Builder methods


+ (void)prepareConnectScene:(id<CTDConnectScene>)connectScene
                  withTrial:(id<CTDTrial>)trial
{
    id<CTDTrialActivityView> trialActivityView =
        [CTDPresentation trialActivityViewForTrial:trial
                                     trialRenderer:connectScene.trialRenderer];

    CTDColorCellGroup* colorCellGroup = [[CTDColorCellGroup alloc]
                                         initWithDefaultColor:CTDDotColor_White
                                            selectedColorSink:nil];

    CTDListOrderTouchMapper* colorCellsTouchMapper =
        [[CTDListOrderTouchMapper alloc] init];

    // TODO: reduce repetition in this section

    id<CTDSelectionRenderer, CTDTouchable> colorCell1Renderer = connectScene.colorSelectionCells[0];
    id<CTDSelectionRenderer, CTDTouchable> colorCell2Renderer = connectScene.colorSelectionCells[1];
    id<CTDSelectionRenderer, CTDTouchable> colorCell3Renderer = connectScene.colorSelectionCells[2];

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

    [connectScene setTouchResponder:[[CTDTrialSceneTouchRouter alloc]
                                     initWithTrialRenderer:connectScene.trialRenderer
                                     dotsTouchMapper:trialActivityView.dotsTouchMapper
                                     freeEndMapper:connectScene.trialTouchMapper
                                     colorCellsTouchResponder:colorCellsTouchResponder]];
}

@end