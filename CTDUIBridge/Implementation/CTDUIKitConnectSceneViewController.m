// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectSceneViewController.h"

#import "CTDPoint+CGConversion.h"
#import "CTDUIKitColorPalette.h"
#import "CTDUIKitConnectionView.h"
#import "CTDUIKitDotView.h"
#import "CTDUIKitDotViewAdapter.h"
#import "CTDPresentation/CTDColorPalette.h"
#import "CTDUtility/CTDPoint.h"




@implementation CTDUIKitConnectSceneViewController
{
    NSMutableDictionary* _colorCellMap;
}

//- (id)initWithNibName:(NSString*)nibNameOrNil
//               bundle:(NSBundle*)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

- (NSDictionary*)colorCellMap
{
    return [_colorCellMap copy];
}



#pragma mark CTDTrialRenderer protocol


- (id<CTDDotRenderer, CTDTouchable>)newDotViewCenteredAt:(CTDPoint*)centerPosition
                                        withInitialColor:(CTDPaletteColorLabel)dotColor
{
    CTDUIKitDotView* newDotView =
        [[CTDUIKitDotView alloc]
         initWithFrame:[self csvc_frameForDotCenteredAt:[centerPosition asCGPoint]]];
    newDotView.dotScale = self.dotDiameter / newDotView.frame.size.height;
    newDotView.selectionIndicatorColor = self.dotSelectionIndicatorColor;
    newDotView.selectionIndicatorThickness = self.dotSelectionIndicatorThickness;
    newDotView.selectionAnimationDuration = self.dotSelectionAnimationDuration;
    [self.view addSubview:newDotView];

    id<CTDDotRenderer, CTDTouchable> dotViewAdapter =
        [[CTDUIKitDotViewAdapter alloc] initWithDotView:newDotView
                                           colorPalette:self.colorPalette];
    [dotViewAdapter changeDotColorTo:dotColor];

    return dotViewAdapter;
}

- (id<CTDDotConnectionRenderer>)
      newDotConnectionViewWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                             secondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    CTDUIKitConnectionView* connectionView = [[CTDUIKitConnectionView alloc]
                                              initWithFrame:self.view.bounds];
    connectionView.lineWidth = self.connectionLineWidth;
    connectionView.lineColor = self.connectionLineColor;
    [connectionView setFirstEndpointPosition:firstEndpointPosition];
    [connectionView setSecondEndpointPosition:secondEndpointPosition];
    [self.view addSubview:connectionView];
    return connectionView;
}



#pragma mark Private methods


- (CGRect)csvc_frameForDotCenteredAt:(CGPoint)center
{
    CGFloat radius = self.dotDiameter / (CGFloat)2.0 + self.dotSelectionIndicatorPadding;
    CGFloat left = center.x - radius;
    CGFloat top = center.y - radius;
    return CGRectMake(left, top, radius * 2, radius * 2);
}

@end
