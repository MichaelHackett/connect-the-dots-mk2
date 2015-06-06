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
}



#pragma mark Initialization


+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frameRect
           dotColor:(UIColor*)dotColor
       colorPalette:(CTDUIKitColorPalette*)colorPalette
{
    self = [super initWithFrame:frameRect];
    if (self) {
        CAShapeLayer* dotLayer = (CAShapeLayer*)self.layer;
        dotLayer.lineWidth = 0;
        dotLayer.opaque = NO;
        dotLayer.fillColor = [dotColor CGColor];

        CGPathRef dotPath = CGPathCreateWithEllipseInRect(self.bounds, NULL);
        dotLayer.path = dotPath;
        CGPathRelease(dotPath);

        _selectionIndicatorController =
            [[CTDUIKitDotSelectionIndicatorController alloc] init];
        [_selectionIndicatorController attachIndicatorToLayer:dotLayer];

        _colorPalette = colorPalette;

        [dotLayer setNeedsDisplay];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
                      dotColor:[UIColor whiteColor]
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
    ((CAShapeLayer*)self.layer).fillColor = [_colorPalette[newDotColor] CGColor];
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
    CGPathRef dotPath = ((CAShapeLayer*)self.layer).path;
    return (BOOL)CGPathContainsPoint(dotPath, NULL, localPoint, false);
}

@end
