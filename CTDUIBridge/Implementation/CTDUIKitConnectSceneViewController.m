// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectSceneViewController.h"

#import "CTDPoint+CGConversion.h"
#import "CTDUIKitColorPalette.h"
#import "CTDUIKitConnectionView.h"
#import "CTDUIKitDotView.h"
#import "CTDUIKitDotViewAdapter.h"
#import "CTDPresentation/CTDColorPalette.h"
#import "CTDUtility/CTDPoint.h"



static CGFloat const kDotDiameter = 75;  // To DrawingConfig
static CGFloat const kSelectionIndicatorPadding = 12.0;  // TEMP: copied from DotView


static CGRect frameForDotCenteredAt(CGPoint center)
{
    CGFloat radius = kDotDiameter / (CGFloat)2.0 + kSelectionIndicatorPadding;
    CGFloat left = center.x - radius;
    CGFloat top = center.y - radius;
    return CGRectMake(left, top, kDotDiameter, kDotDiameter);
}





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
         initWithFrame:frameForDotCenteredAt([centerPosition asCGPoint])];
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
    CTDUIKitConnectionView* connectionView =
        [[CTDUIKitConnectionView alloc]
         initWithLineWidth:self.connectionLineWidth
                 lineColor:self.connectionLineColor];
    [connectionView setFirstEndpointPosition:firstEndpointPosition];
    [connectionView setSecondEndpointPosition:secondEndpointPosition];
    [self.view addSubview:connectionView];
    return connectionView;
}

@end
