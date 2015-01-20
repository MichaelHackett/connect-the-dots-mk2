// CTDUIKitDrawingConfig:
//     Parameter settings for drawing code.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDColorPalette.h"



@interface CTDUIKitDrawingConfig : NSObject <NSCopying>

@property (assign, readonly, nonatomic) float connectionLineWidth;
@property (assign, readonly, nonatomic) CGColorRef connectionLineColor;

- (UIColor*)colorFor:(CTDPaletteColor)paletteColor;

@end
