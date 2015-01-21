// CTDUIKitDotView:
//     UIKit renderer for the "dots" to be connected. They are drawn as circles
//     filled with a solid color.
//
// Copyright 2013-5 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDDotRenderer.h"
#import "CTDPresentation/CTDTouchable.h"



@interface CTDUIKitDotView : UIView <CTDDotRenderer, CTDTouchable>

@property (copy, nonatomic) NSDictionary* dotColorMap; // @(CTDPaletteColor) -> UIColor*


- (id)initWithFrame:(CGRect)frameRect
           dotColor:(UIColor*)dotColor;

@end
