// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitStandardViewController.h"

#import "CTDPoint+CGConversion.h"
#import "ExtensionPoints/CTDTouchResponder.h"
#import "CTDUtility/CTDPoint.h"




static id<NSCopying> keyForTouch(UITouch* touch)
{
    return [NSValue valueWithNonretainedObject:touch];
}





@implementation CTDUIKitStandardViewController
{
    NSMutableArray* _touchResponders;
    NSMutableDictionary* _touchTrackersMap; // UITouch -> NSSet(CTDTouchTrackers)
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
    _touchResponders = [[NSMutableArray alloc] init];
    _touchTrackersMap = [[NSMutableDictionary alloc] init];
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}






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
