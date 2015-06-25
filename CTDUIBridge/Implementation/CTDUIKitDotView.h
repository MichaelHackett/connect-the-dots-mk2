// CTDUIKitDotView:
//     A UIView that displays a filled circle, with an animated ring that can
//     be used as an indicator.
//
// Copyright 2013-5 Michael Hackett. All rights reserved.



@interface CTDUIKitDotView : UIView

@property (copy, nonatomic) UIColor* dotColor;
// The proportion of view's frame which the dot occupies (0.0-1.0).
@property (assign, nonatomic) CGFloat dotScale;

@property (copy, nonatomic) UIColor* selectionIndicatorColor;
@property (assign, nonatomic) CGFloat selectionIndicatorThickness;
@property (assign, nonatomic) CGFloat selectionAnimationDuration; // seconds
@property (assign, nonatomic) BOOL selectionIndicatorIsVisible;

@property (assign, nonatomic, readonly) CGPoint connectionPoint;

- (BOOL)containsTouchLocation:(CGPoint)touchLocation;

@end
