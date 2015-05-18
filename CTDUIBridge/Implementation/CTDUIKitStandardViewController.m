// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitStandardViewController.h"

#import "CTDUIKitTouchRoutingTable.h"
#import "CTDPoint+CGConversion.h"
#import "ExtensionPoints/CTDTouchResponder.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDUIKitStandardViewController
{
    CTDUIKitTouchRoutingTable* _touchRoutingTable;
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
    _touchRoutingTable = [[CTDUIKitTouchRoutingTable alloc] init];
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
            [_touchRoutingTable setTracker:touchTracker forTouch:touch];
        }
    }
}

- (void)touchesMoved:(NSSet*)touches
           withEvent:(__unused UIEvent*)event
{
    for (UITouch* touch in touches) {
        CTDPoint* newLocation =
            [CTDPoint fromCGPoint:[touch locationInView:self.view]];
        [[_touchRoutingTable trackerForTouch:touch] touchDidMoveTo:newLocation];
    }
}

- (void)touchesEnded:(NSSet*)touches
           withEvent:(__unused UIEvent*)event
{
    for (UITouch* touch in touches) {
        [[_touchRoutingTable trackerForTouch:touch] touchDidEnd];
        [_touchRoutingTable setTracker:nil forTouch:touch];
    }
}

- (void)touchesCancelled:(NSSet*)touches
               withEvent:(__unused UIEvent*)event
{
    for (UITouch* touch in touches) {
        [[_touchRoutingTable trackerForTouch:touch] touchWasCancelled];
        [_touchRoutingTable setTracker:nil forTouch:touch];
    }
}

@end
