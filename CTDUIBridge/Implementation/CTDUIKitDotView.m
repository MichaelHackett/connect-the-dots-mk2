// Copyright 2013-5 Michael Hackett. All rights reserved.

#import "CTDUIKitDotView.h"

#import "CTDCoreGraphicsUtils.h"
#import "CTDPoint+CGConversion.h"
#import "CTDUIKitColorPalette.h"
#import "CTDUIKitDotSelectionIndicatorController.h"
#import "CTDUtility/CTDPoint.h"
#import <QuartzCore/CAShapeLayer.h>



@implementation CTDUIKitDotView
{
    CTDUIKitDotSelectionIndicatorController* _selectionIndicatorController;
    CTDUIKitColorPalette* _colorPalette;
    // Copy of parent's layer property, cast to the correct type (for convenience).
    __unsafe_unretained CAShapeLayer* _dotLayer;
}



#pragma mark Initialization


+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frameRect
           dotColor:(CTDPaletteColorLabel)dotColor
       colorPalette:(CTDUIKitColorPalette*)colorPalette
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _dotLayer = (CAShapeLayer*)self.layer;
        _dotLayer.lineWidth = 0;
        _dotLayer.opaque = NO;
        _dotLayer.fillColor = [colorPalette[dotColor] CGColor];

        CGPathRef dotPath = CGPathCreateWithEllipseInRect(self.bounds, NULL);
        _dotLayer.path = dotPath;
        CGPathRelease(dotPath);

        _selectionIndicatorController =
            [[CTDUIKitDotSelectionIndicatorController alloc] init];
        [_selectionIndicatorController attachIndicatorToLayer:_dotLayer];

        _colorPalette = colorPalette;

        [_dotLayer setNeedsDisplay];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
                      dotColor:@""
                  colorPalette:[[CTDUIKitColorPalette alloc] init]];
}




#pragma mark CTDDotRenderer protocol


//- (void)discardView
//{
//    [self removeFromSuperview];
//}

- (CTDPoint*)connectionPoint
{
    return [CTDPoint fromCGPoint:ctdCGRectCenter(self.frame)];
}

- (void)changeDotColorTo:(CTDPaletteColorLabel)newDotColor
{
    _dotLayer.fillColor = [_colorPalette[newDotColor] CGColor];
}

- (void)showSelectionIndicator
{
    [_selectionIndicatorController showIndicator];
}

- (void)hideSelectionIndicator
{
    [_selectionIndicatorController hideIndicator];
}



#pragma mark CTDTouchable protocol


- (BOOL)containsTouchLocation:(CTDPoint*)touchLocation
{
    CGPoint localPoint = [self convertPoint:[touchLocation asCGPoint]
                                   fromView:self.superview];
    CGPathRef dotPath = _dotLayer.path;
    return (BOOL)CGPathContainsPoint(dotPath, NULL, localPoint, false);
}

@end
