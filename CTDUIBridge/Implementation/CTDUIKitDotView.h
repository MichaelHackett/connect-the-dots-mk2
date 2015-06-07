// CTDUIKitDotView:
//     UIKit renderer for the "dots" to be connected. They are drawn as circles
//     filled with a solid color.
//
// Copyright 2013-5 Michael Hackett. All rights reserved.



@interface CTDUIKitDotView : UIView

@property (strong, nonatomic) UIColor* dotColor;
@property (assign, nonatomic) BOOL selectionIndicatorIsVisible;
@property (assign, nonatomic, readonly) CGPoint connectionPoint;

- (BOOL)containsTouchLocation:(CGPoint)touchLocation;

@end
