// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDSceneBuilder.h"

#import "CTDUIKitDrawingConfig.h"
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
#import "CTDPresentation/CTDSelectionRenderer.h"
#import "CTDUIBridge/CTDUIKitConnectSceneViewController.h"
#import "CTDUtility/CTDPoint.h"


static NSString* const kCTDUIKitConnectSceneViewControllerNibName =
          @"CTDUIKitConnectSceneViewController";

// Macro for defining sample data
#define dot(COLOR,X,Y) [[CTDDot alloc] initWithColor:COLOR position:[[CTDPoint alloc] initWithX:X y:Y]]


// Merge drawing config into this class (rather than separate class)?
// If config gets loaded from a file eventually, then makes sense to keep it separate.



@implementation CTDSceneBuilder
{
    CTDUIKitDrawingConfig* _drawingConfig;
}


#pragma mark Initialization


- (instancetype)initWithDrawingConfig:(CTDUIKitDrawingConfig*)drawingConfig
{
    self = [super init];
    if (self) {
        _drawingConfig = drawingConfig;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark Builder methods


- (void)prepareConnectScene:(CTDUIKitConnectSceneViewController*)connectVC
{
    // VC properties that must be set before `viewDidLoad` runs (BAD!)
    connectVC.connectionLineWidth = _drawingConfig.connectionLineWidth;
    connectVC.connectionLineColor = _drawingConfig.connectionLineColor;
    connectVC.colorPalette = _drawingConfig.colorPalette;

    [connectVC view]; // force VC views to load

    // TODO: Replace with data passed in
    NSArray* dotList = @[
        dot(CTDDotColor_Green, 100, 170),
        dot(CTDDotColor_Red, 600, 400),
        dot(CTDDotColor_Blue, 250, 650)
    ];

    CTDDotSetPresenter* dotSetPresenter = [[CTDDotSetPresenter alloc]
                                           initWithDotList:dotList
                                             trialRenderer:connectVC];  // TODO: Make a connect view class to become the renderer

    CTDColorCellGroup* colorCellGroup = [[CTDColorCellGroup alloc]
                                         initWithDefaultColor:CTDDotColor_White
                                            selectedColorSink:nil];

    CTDListOrderTouchMapper* colorCellsTouchMapper =
        [[CTDListOrderTouchMapper alloc] init];

    // TODO: reduce repetition in this section

    id<CTDSelectionRenderer, CTDTouchable> colorCell1Renderer = connectVC.colorSelectionCells[0];
    id<CTDSelectionRenderer, CTDTouchable> colorCell2Renderer = connectVC.colorSelectionCells[1];
    id<CTDSelectionRenderer, CTDTouchable> colorCell3Renderer = connectVC.colorSelectionCells[2];

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

    connectVC.touchResponder = [[CTDTrialSceneTouchRouter alloc]
                                initWithTrialRenderer:connectVC
                                dotsTouchMapper:[dotSetPresenter dotsTouchMapper]
                                colorCellsTouchResponder:colorCellsTouchResponder];
}

@end
