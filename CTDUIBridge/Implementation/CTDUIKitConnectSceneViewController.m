// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectSceneViewController.h"

#import "CTDPoint+CGConversion.h"
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

static id<NSCopying> keyForTouch(UITouch* touch)
{
    return [NSValue valueWithNonretainedObject:touch];
}





@interface CTDUIKitConnectSceneViewController ()

@end

@implementation CTDUIKitConnectSceneViewController
{
    NSMutableArray* _dotViews;
    NSMutableArray* _touchResponders;
    NSMutableDictionary* _colorCellMap;

    // maps UITouch to a NSSet of CTDTouchTrackers
    NSMutableDictionary* _touchTrackersMap;
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
    _touchResponders = [[NSMutableArray alloc] init];
    _colorCellMap = [[NSMutableDictionary alloc] init];
    _touchTrackersMap = [[NSMutableDictionary alloc] init];

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




#pragma mark CTDTouchInputSource protocol


// TODO: Move distribution to presentation layer, if possible.

- (void)addTouchResponder:(id<CTDTouchResponder>)touchResponder
{
    [_touchResponders addObject:touchResponder];
}

- (void)removeTouchResponder:(id<CTDTouchResponder>)touchResponder
{
    [_touchResponders removeObject:touchResponder];
}



#pragma mark Touch distribution


- (void)touchesBegan:(NSSet*)touches
           withEvent:(__unused UIEvent*)event
{
    for (UITouch* touch in touches) {
        CTDPoint* touchLocation =
            [CTDPoint fromCGPoint:[touch locationInView:self.view]];

        NSMutableSet* trackersForThisTouch = [[NSMutableSet alloc] init];
        for (id<CTDTouchResponder> touchResponder in _touchResponders) {
            id<CTDTouchTracker> touchTracker =
                [touchResponder trackerForTouchStartingAt:touchLocation];
            if (touchTracker) {
                [trackersForThisTouch addObject:touchTracker];
            }
        }

        if ([trackersForThisTouch count] > 0) {
            [_touchTrackersMap setObject:trackersForThisTouch
                                  forKey:keyForTouch(touch)];
        }
    }
}

- (void)touchesMoved:(NSSet*)touches
           withEvent:(__unused UIEvent*)event
{
    for (UITouch* touch in touches) {
        CTDPoint* newLocation =
            [CTDPoint fromCGPoint:[touch locationInView:self.view]];

        NSSet* trackersForTouch = [_touchTrackersMap objectForKey:keyForTouch(touch)];
        for (id<CTDTouchTracker> tracker in trackersForTouch) {
            [tracker touchDidMoveTo:newLocation];
        }
    }
}

- (void)touchesEnded:(NSSet*)touches
           withEvent:(__unused UIEvent*)event
{
    for (UITouch* touch in touches) {
        NSSet* trackersForTouch = [_touchTrackersMap objectForKey:keyForTouch(touch)];
        for (id<CTDTouchTracker> tracker in trackersForTouch) {
            [tracker touchDidEnd];
        }
        [_touchTrackersMap removeObjectForKey:keyForTouch(touch)];
    }
}

- (void)touchesCancelled:(NSSet*)touches
               withEvent:(__unused UIEvent*)event
{
    for (UITouch* touch in touches) {
        NSSet* trackersForTouch = [_touchTrackersMap objectForKey:keyForTouch(touch)];
        for (id<CTDTouchTracker> tracker in trackersForTouch) {
            [tracker touchWasCancelled];
        }
        [_touchTrackersMap removeObjectForKey:keyForTouch(touch)];
    }
}

@end
