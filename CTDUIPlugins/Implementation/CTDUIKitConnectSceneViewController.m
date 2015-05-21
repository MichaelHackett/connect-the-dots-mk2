// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectSceneViewController.h"

#import "CTDUIKitColorCell.h"
#import "CTDUIKitConnectionView.h"
#import "CTDUIKitDotView.h"
#import "CTDUIKitToolbar.h"
#import "CTDUIBridge/CTDUIKitColorPalette.h"
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
    _colorCellMap = [[NSMutableDictionary alloc] init];

    CTDUIKitToolbar* toolbar = [[CTDUIKitToolbar alloc]
                                initWithFrame:CGRectMake(200, 50, 400, 60)];
    CTDUIKitColorCell* colorCell1 = [[CTDUIKitColorCell alloc]
                                     initWithColor:self.colorPalette[CTDPaletteColor_DotType1]];
    CTDUIKitColorCell* colorCell2 = [[CTDUIKitColorCell alloc]
                                     initWithColor:self.colorPalette[CTDPaletteColor_DotType2]];
    CTDUIKitColorCell* colorCell3 = [[CTDUIKitColorCell alloc]
                                     initWithColor:self.colorPalette[CTDPaletteColor_DotType3]];
    [toolbar addCell:colorCell1];
    [toolbar addCell:colorCell2];
    [toolbar addCell:colorCell3];
    [self.view addSubview:toolbar];

    [_colorCellMap setObject:colorCell1 forKey:CTDPaletteColor_DotType1];
    [_colorCellMap setObject:colorCell2 forKey:CTDPaletteColor_DotType2];
    [_colorCellMap setObject:colorCell3 forKey:CTDPaletteColor_DotType3];
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
