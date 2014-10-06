// CTDUIKitDrawingConfig:
//     Parameter settings for drawing code.
//
// TODO: Load these values from a plist or XML file.
//
// Copyright 2014 Michael Hackett. All rights reserved.


@interface CTDUIKitDrawingConfig : NSObject <NSCopying>

@property (assign, readonly, nonatomic) float connectionLineWidth;
@property (assign, readonly, nonatomic) CGColorRef connectionLineColor;

@end
