// CTDUIKitConnectionView:
//     UIKit renderer for dot-to-dot connections. The connections are drawn as
//     solid lines between the two given points.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.



@interface CTDUIKitConnectionView : UIView

@property (assign, nonatomic) CGFloat lineWidth;
@property (copy, nonatomic) UIColor* lineColor;
@property (assign, nonatomic) CGPoint firstEndpoint;
@property (assign, nonatomic) CGPoint secondEndpoint;

@end
