// CTDUIKitConnectTheDotsView:
//     A UIView to be a container for the dots-and-connections activity.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@class CTDUIKitDotView;
@class CTDUIKitLineView;



@interface CTDUIKitConnectTheDotsView : UIView

// Note: At this time, changes to these properties affect only dots and
// connections created in the future. Existing elements are not updated.
// As the current sole use case never changes the values, it was deemed
// unnecessary to add such support at this time.

@property (assign, nonatomic) CGFloat dotDiameter; // in pixels
@property (strong, nonatomic) UIColor* dotSelectionIndicatorColor;
@property (assign, nonatomic) CGFloat dotSelectionIndicatorThickness;
@property (assign, nonatomic) CGFloat dotSelectionIndicatorPadding;
@property (assign, nonatomic) CGFloat dotSelectionAnimationDuration; // seconds

@property (assign, nonatomic) CGFloat connectionLineWidth;
@property (strong, nonatomic) UIColor* connectionLineColor;


- (CTDUIKitDotView*)newDotCenteredAt:(CGPoint)center;
- (CTDUIKitLineView*)newConnection;

@end
