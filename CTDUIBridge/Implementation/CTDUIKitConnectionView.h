// CTDUIKitConnectionView:
//     UIKit renderer for dot-to-dot connections. The connections are drawn as
//     solid lines between the two given points. The view automatically resizes
//     to match the immediate superview of which it is a part, so there is no
//     need (and no point) to setting the connection view's frame.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDDotConnectionRenderer.h"



@interface CTDUIKitConnectionView : UIView <CTDDotConnectionRenderer>

@property (assign, nonatomic) CGFloat lineWidth;
@property (copy, nonatomic) UIColor* lineColor;

@end
