// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectSceneViewController.h"

#import "CTDPoint+CGConversion.h"
#import "CTDUIKitColorPalette.h"
#import "CTDUIKitConnectionView.h"
#import "CTDUIKitDotView.h"
#import "CTDUIKitDotViewAdapter.h"
#import "CTDPresentation/CTDColorPalette.h"
#import "CTDUtility/CTDPoint.h"



static CGFloat const kDotDiameter = 65;  // To DrawingConfig
static UIColor* kSelectionIndicatorColor;  // set by +initialize
static CGFloat const kSelectionIndicatorThickness = 3.0;
static CGFloat const kSelectionIndicatorPadding = 15.0;


static CGRect frameForDotCenteredAt(CGPoint center)
{
    CGFloat radius = kDotDiameter / (CGFloat)2.0 + kSelectionIndicatorPadding;
    CGFloat left = center.x - radius;
    CGFloat top = center.y - radius;
    return CGRectMake(left, top, radius * 2, radius * 2);
}





@implementation CTDUIKitConnectSceneViewController
{
    NSMutableDictionary* _colorCellMap;
}

+ (void)initialize
{
    if (self == [CTDUIKitConnectSceneViewController class]) {
        kSelectionIndicatorColor = [UIColor purpleColor];  // should come from DrawingConfig
    }
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
    newDotView.dotScale = kDotDiameter / newDotView.frame.size.height;
    newDotView.selectionIndicatorColor = kSelectionIndicatorColor;
    newDotView.selectionIndicatorThickness = kSelectionIndicatorThickness;
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
