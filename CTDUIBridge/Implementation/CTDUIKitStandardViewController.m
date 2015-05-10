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
    NSMutableDictionary* _touchTrackerMap; // UITouch -> CTDTouchTracker
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
    _touchTrackerMap = [[NSMutableDictionary alloc] init];
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}






#pragma mark Touch distribution


- (void)touchesBegan:(NSSet*)touches
           withEvent:(__unused UIEvent*)event
{
    for (UITouch* touch in touches) {
        CTDPoint* touchLocation =
            [CTDPoint fromCGPoint:[touch locationInView:self.view]];
        id<CTDTouchTracker> touchTracker =
            [self.touchResponder trackerForTouchStartingAt:touchLocation];
        if (touchTracker) {
            [_touchTrackerMap setObject:touchTracker forKey:keyForTouch(touch)];
        }
    }
}

- (void)touchesMoved:(NSSet*)touches
           withEvent:(__unused UIEvent*)event
{
    for (UITouch* touch in touches) {
        CTDPoint* newLocation =
            [CTDPoint fromCGPoint:[touch locationInView:self.view]];
        [[_touchTrackerMap objectForKey:keyForTouch(touch)] touchDidMoveTo:newLocation];
    }
}

- (void)touchesEnded:(NSSet*)touches
           withEvent:(__unused UIEvent*)event
{
    for (UITouch* touch in touches) {
        [[_touchTrackerMap objectForKey:keyForTouch(touch)] touchDidEnd];
        [_touchTrackerMap removeObjectForKey:keyForTouch(touch)];
    }
}

- (void)touchesCancelled:(NSSet*)touches
               withEvent:(__unused UIEvent*)event
{
    for (UITouch* touch in touches) {
        [[_touchTrackerMap objectForKey:keyForTouch(touch)] touchWasCancelled];
        [_touchTrackerMap removeObjectForKey:keyForTouch(touch)];
    }
}

@end
