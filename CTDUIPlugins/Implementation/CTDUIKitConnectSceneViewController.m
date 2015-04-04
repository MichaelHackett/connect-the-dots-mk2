// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectSceneViewController.h"

#import "CTDUIKitColorCell.h"
#import "CTDUIKitConnectionView.h"
#import "CTDUIKitDotView.h"
#import "CTDUIKitToolbar.h"
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
    CTDUIKitColorCell* redCell = [[CTDUIKitColorCell alloc]
                                  initWithColor:self.dotColorMap[@(CTDPaletteColor_RedDot)]];
    CTDUIKitColorCell* greenCell = [[CTDUIKitColorCell alloc]
                                    initWithColor:self.dotColorMap[@(CTDPaletteColor_GreenDot)]];
    CTDUIKitColorCell* blueCell = [[CTDUIKitColorCell alloc]
                                   initWithColor:self.dotColorMap[@(CTDPaletteColor_BlueDot)]];
    [toolbar addCell:redCell];
    [toolbar addCell:greenCell];
    [toolbar addCell:blueCell];
    [self.view addSubview:toolbar];

    [_colorCellMap setObject:redCell forKey:@(CTDPaletteColor_RedDot)];
    [_colorCellMap setObject:greenCell forKey:@(CTDPaletteColor_GreenDot)];
    [_colorCellMap setObject:blueCell forKey:@(CTDPaletteColor_BlueDot)];
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
                                        withInitialColor:(CTDPaletteColor)dotColor
{
    CGPoint cgCenterPosition = CGPointMake(centerPosition.x, centerPosition.y);
    CTDUIKitDotView* newDotView =
        [[CTDUIKitDotView alloc]
         initWithFrame:frameForDotCenteredAt(cgCenterPosition)
         dotColor:self.dotColorMap[@(dotColor)]];
    newDotView.dotColorMap = [self.dotColorMap copy];
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
