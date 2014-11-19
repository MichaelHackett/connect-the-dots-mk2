// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDUIKitTargetView.h"

#import "CTDCoreGraphicsUtils.h"
#import "CTDUIKitDrawingConfig.h"
#import "CTDUIKitTargetSelectionIndicatorController.h"
#import "CTDUtility/CTDPoint.h"
#import "CTDPoint+CGConversion.h"
#import <QuartzCore/CAShapeLayer.h>



@implementation CTDUIKitTargetView
{
    CTDUIKitTargetSelectionIndicatorController* _selectionIndicatorController;
}



#pragma mark Initialization


+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frameRect
        targetColor:(UIColor*)targetColor
{
    self = [super initWithFrame:frameRect];
    if (self) {
        CAShapeLayer* targetLayer = (CAShapeLayer*)self.layer;
        targetLayer.lineWidth = 0;
        targetLayer.opaque = NO;
        targetLayer.fillColor = [targetColor CGColor];

        CGPathRef targetPath = CGPathCreateWithEllipseInRect(self.bounds, NULL);
        targetLayer.path = targetPath;
        CGPathRelease(targetPath);

        _selectionIndicatorController =
            [[CTDUIKitTargetSelectionIndicatorController alloc] init];
        [_selectionIndicatorController attachIndicatorToLayer:targetLayer];

        [targetLayer setNeedsDisplay];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame targetColor:[UIColor whiteColor]];
}




#pragma mark CTDTargetRenderer protocol


//- (void)discardView
//{
//    [self removeFromSuperview];
//}

- (CTDPoint*)connectionPoint
{
    return [CTDPoint fromCGPoint:ctdCGRectCenter(self.frame)];
}

- (void)changeTargetColorTo:(CTDPaletteColor)newTargetColor
{
    ((CAShapeLayer*)self.layer).fillColor =
        [[self.drawingConfig colorFor:newTargetColor] CGColor];
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
    CGPathRef targetPath = ((CAShapeLayer*)self.layer).path;
    return (BOOL)CGPathContainsPoint(targetPath, NULL, localPoint, false);
}

@end
