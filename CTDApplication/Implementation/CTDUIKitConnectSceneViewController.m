// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectSceneViewController.h"

#import "CTDPoint+CGConversion.h"
#import "CTDUIKitTargetView.h"
#import "CTDUIKitToolbar.h"
#import "CTDUtility/CTDPoint.h"



static CGFloat const kTargetDiameter = 75;


static CGRect frameForTargetCenteredAt(CGPoint center)
{
    CGFloat radius = kTargetDiameter / (CGFloat)2.0;
    CGFloat left = center.x - radius;
    CGFloat top = center.y - radius;
    return CGRectMake(left, top, kTargetDiameter, kTargetDiameter);
}

static id<NSCopying> keyForTouch(UITouch* touch)
{
    return [NSValue valueWithNonretainedObject:touch];
}





@interface CTDUIKitConnectSceneViewController ()

@end

@implementation CTDUIKitConnectSceneViewController
{
    NSMutableArray* _targetViews;
    NSMutableArray* _touchResponders;

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
    _targetViews = [[NSMutableArray alloc] init];
    _touchResponders = [[NSMutableArray alloc] init];
    _touchTrackersMap = [[NSMutableDictionary alloc] init];

    CTDUIKitToolbar* toolbar = [[CTDUIKitToolbar alloc]
                                initWithFrame:CGRectMake(200, 50, 400, 60)];
    UIView* greenToolbarCell = [[UIView alloc]
                                initWithFrame:CGRectMake(0, 0, 100, 0)];
    greenToolbarCell.backgroundColor = [UIColor greenColor];
    UIView* redToolbarCell = [[UIView alloc]
                              initWithFrame:CGRectMake(0, 0, 100, 0)];
    redToolbarCell.backgroundColor = [UIColor redColor];
    [toolbar addSubview:greenToolbarCell];
    [toolbar addSubview:redToolbarCell];

    [self.view addSubview:toolbar];
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}



#pragma mark - CTDTargetViewRenderer protocol


- (id<CTDTargetView>)newTargetViewCenteredAt:(CTDPoint*)centerPosition
{
    CGPoint cgCenterPosition = CGPointMake(centerPosition.x, centerPosition.y);
    CTDUIKitTargetView* newTargetView =
        [[CTDUIKitTargetView alloc]
         initWithFrame:frameForTargetCenteredAt(cgCenterPosition)];
    [self.view addSubview:newTargetView];
    [_targetViews addObject:newTargetView];
    return newTargetView;
}



#pragma mark - CTDTouchInputSource protocol


// TODO: Move distribution to presentation layer, if possible.

- (void)addTouchResponder:(id<CTDTouchResponder>)touchResponder
{
    [_touchResponders addObject:touchResponder];
}

- (void)removeTouchResponder:(id<CTDTouchResponder>)touchResponder
{
    [_touchResponders removeObject:touchResponder];
}



#pragma mark - Touch distribution


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
