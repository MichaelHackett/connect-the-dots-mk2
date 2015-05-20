// CTDUIKitDrawingConfig:
//     Parameter settings for drawing code.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

@class CTDUIKitColorPalette;



@interface CTDUIKitDrawingConfig : NSObject <NSCopying>

@property (assign, readonly, nonatomic) float connectionLineWidth;
@property (strong, readonly, nonatomic) UIColor* connectionLineColor;
@property (strong, readonly, nonatomic) CTDUIKitColorPalette* colorPalette;

@end
