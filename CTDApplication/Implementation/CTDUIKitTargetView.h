// CTDUIKitTargetView:
//     UIKit renderer for task targets. The targets are drawn as circles
//     filled with a solid color.
//
// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDTargetRenderer.h"
#import "CTDPresentation/CTDTouchable.h"

@class CTDUIKitDrawingConfig;



@interface CTDUIKitTargetView : UIView <CTDTargetRenderer, CTDTouchable>

@property (copy, nonatomic) CTDUIKitDrawingConfig* drawingConfig;


- (id)initWithFrame:(CGRect)frameRect
        targetColor:(UIColor*)targetColor;

@end
