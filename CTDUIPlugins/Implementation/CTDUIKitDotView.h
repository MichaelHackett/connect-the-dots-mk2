// CTDUIKitDotView:
//     UIKit renderer for the "dots" to be connected. They are drawn as circles
//     filled with a solid color.
//
// Copyright 2013-5 Michael Hackett. All rights reserved.

#import "CTDTouchable.h"
#import "CTDPresentation/CTDDotRenderer.h"

@class CTDUIKitColorPalette;



@interface CTDUIKitDotView : UIView <CTDDotRenderer, CTDTouchable>

- (id)initWithFrame:(CGRect)frameRect
           dotColor:(UIColor*)dotColor
       colorPalette:(CTDUIKitColorPalette*)colorPalette;

@end
