// CTDUIKitDotView:
//     UIKit renderer for the "dots" to be connected. They are drawn as circles
//     filled with a solid color.
//
// Copyright 2013-5 Michael Hackett. All rights reserved.



@interface CTDUIKitDotView : UIView

@property (strong, nonatomic) UIColor* dotColor;
// The proportion of view's frame which the dot occupies (0.0-1.0).
@property (assign, nonatomic) CGFloat dotScale;

@property (strong, nonatomic) UIColor* selectionIndicatorColor;
@property (assign, nonatomic) CGFloat selectionIndicatorThickness;
@property (assign, nonatomic) CGFloat selectionAnimationDuration; // seconds
@property (assign, nonatomic) BOOL selectionIndicatorIsVisible;

@property (assign, nonatomic, readonly) CGPoint connectionPoint;

- (BOOL)containsTouchLocation:(CGPoint)touchLocation;

@end
