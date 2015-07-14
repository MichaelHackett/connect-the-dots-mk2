// CTDUIKitStandardViewController:
//     Generic View Controller for scenes controlled by the UI Bridge module.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

@protocol CTDTouchResponder;


@interface CTDUIKitStandardViewController : UIViewController

@property (strong, nonatomic) id<CTDTouchResponder> touchResponder;

@end
