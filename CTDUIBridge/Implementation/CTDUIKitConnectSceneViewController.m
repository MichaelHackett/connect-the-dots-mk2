// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectSceneViewController.h"

#import "CTDUIKitColorPalette.h"
#import "CTDUIPlugins/CTDUIKitConnectionView.h"
#import "CTDUIPlugins/CTDUIKitDotView.h"
#import "CTDPresentation/CTDColorPalette.h"
#import "CTDUtility/CTDPoint.h"



static CGFloat const kDotDiameter = 75;


static CGRect frameForDotCenteredAt(CGPoint center)
{
    CGFloat radius = kDotDiameter / (CGFloat)2.0;
    CGFloat left = center.x - radius;
    CGFloat top = center.y - radius;
    return CGRectMake(left, top, kDotDiameter, kDotDiameter);
}





@implementation CTDUIKitConnectSceneViewController
{
    NSMutableArray* _dotViews;
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
    _dotViews = [[NSMutableArray alloc] init];
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
    CGPoint cgCenterPosition = CGPointMake(centerPosition.x, centerPosition.y);
    CTDUIKitDotView* newDotView =
        [[CTDUIKitDotView alloc]
         initWithFrame:frameForDotCenteredAt(cgCenterPosition)
         dotColor:self.colorPalette[dotColor]
         colorPalette:self.colorPalette];
    [self.view addSubview:newDotView];
    [_dotViews addObject:newDotView];
    return newDotView;
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
