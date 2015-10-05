// CTDUIKitLineView:
//     A UIView that renders a line whose endpoints can be changed dynamically.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.



@interface CTDUIKitLineView : UIView

@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor* lineColor;
@property (assign, nonatomic) CGPoint firstEndpoint;
@property (assign, nonatomic) CGPoint secondEndpoint;

@end
