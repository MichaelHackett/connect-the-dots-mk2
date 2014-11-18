// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDUIKitTargetView.h"

#import "CTDCoreGraphicsUtils.h"
#import "CTDUIKitTargetSelectionIndicatorController.h"
#import "CTDUtility/CTDPoint.h"
#import "CTDPoint+CGConversion.h"
#import <QuartzCore/CAShapeLayer.h>



@implementation CTDUIKitTargetView
{
    CTDUIKitTargetSelectionIndicatorController* _selectionIndicatorController;
}

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        CAShapeLayer* targetLayer = (CAShapeLayer*)self.layer;
        targetLayer.lineWidth = 0;
        targetLayer.opaque = NO;
        targetLayer.fillColor = [[UIColor whiteColor] CGColor];

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



#pragma mark CTDTargetView protocol


//- (void)discardView
//{
//    [self removeFromSuperview];
//}

- (void)showSelectionIndicator
{
    [_selectionIndicatorController showIndicator];
}

- (void)hideSelectionIndicator
{
    [_selectionIndicatorController hideIndicator];
}

- (CTDPoint*)connectionPoint
{
    return [CTDPoint fromCGPoint:ctdCGRectCenter(self.frame)];
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
