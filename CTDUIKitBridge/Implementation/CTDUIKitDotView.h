// CTDUIKitDotView:
//     A UIView that displays a filled circle, with an animated ring that can
//     be used as an indicator.
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

// The given point should be in the receiver's coordinate system. Unlike
// `pointInside:withEvent:`, however, this method takes into account the
// visible region of the drawn dot; points within the view's rectangular bounds
// but outside of the dot will not be considered within the dot.
- (BOOL)dotContainsPoint:(CGPoint)point;

@end
