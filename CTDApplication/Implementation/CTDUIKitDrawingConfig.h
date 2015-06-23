// CTDUIKitDrawingConfig:
//     Parameter settings for drawing code.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

@class CTDUIKitColorPalette;



@interface CTDUIKitDrawingConfig : NSObject <NSCopying>

@property (assign, readonly, nonatomic) CGFloat dotDiameter; // in pixels
@property (copy, readonly, nonatomic) UIColor* dotSelectionIndicatorColor;
@property (assign, readonly, nonatomic) CGFloat dotSelectionIndicatorThickness;
@property (assign, readonly, nonatomic) CGFloat dotSelectionIndicatorPadding;
@property (assign, readonly, nonatomic) CGFloat dotSelectionAnimationDuration; // seconds

@property (assign, readonly, nonatomic) float connectionLineWidth;
@property (copy, readonly, nonatomic) UIColor* connectionLineColor;

@property (strong, readonly, nonatomic) CTDUIKitColorPalette* colorPalette;

@end
