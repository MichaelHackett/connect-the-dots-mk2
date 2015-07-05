// CTDUIKitDrawingConfig:
//     Parameter settings for drawing code.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

@class CTDUIKitColorPalette;



@interface CTDUIKitDrawingConfig : NSObject <NSCopying>

@property (assign, nonatomic) CGFloat dotDiameter; // in pixels
@property (copy, nonatomic) UIColor* dotSelectionIndicatorColor;
@property (assign, nonatomic) CGFloat dotSelectionIndicatorThickness;
@property (assign, nonatomic) CGFloat dotSelectionIndicatorPadding;
@property (assign, nonatomic) CGFloat dotSelectionAnimationDuration; // seconds

@property (assign, nonatomic) float connectionLineWidth;
@property (copy, nonatomic) UIColor* connectionLineColor;

@property (strong, nonatomic) CTDUIKitColorPalette* colorPalette;

@end
