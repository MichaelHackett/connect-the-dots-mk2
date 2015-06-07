// Copyright 2013-5 Michael Hackett. All rights reserved.

#import "CTDUIKitDotView.h"

#import "CTDAnimationUtils.h"
#import "CTDCoreGraphicsUtils.h"
#import "CTDPoint+CGConversion.h"
#import "CTDUIKitAnimator.h"
#import "CTDUIKitColorPalette.h"
#import "CTDUtility/CTDPoint.h"
#import <QuartzCore/CAShapeLayer.h>


// TODO: Move to CTDUIKitDrawingConfig

// Dot selection ring display parameters:
static CGColorRef kSelectionIndicatorColor;
static CGFloat const kSelectionIndicatorThickness = 3.0;
static CGFloat const kSelectionIndicatorPadding = 12.0;
static CGFloat const kSelectionAnimationDuration = (CGFloat)0.12;  // seconds
static NSString* const kSelectionIndicatorLayerName = @"Selection indicator";



@interface CTDUIKitDotViewSelectionIndicatorFactory : NSObject
@end
@implementation CTDUIKitDotViewSelectionIndicatorFactory

// make into a plain function?
+ (CAShapeLayer*)indicatorLayerWithSize:(CGSize)layerSize
{
    CAShapeLayer* indicatorLayer = [CAShapeLayer layer];
    indicatorLayer.name = kSelectionIndicatorLayerName;
    indicatorLayer.lineWidth = kSelectionIndicatorThickness;  // config.selectionIndicatorThickness
    indicatorLayer.strokeColor = kSelectionIndicatorColor;  // config.selectionIndicatorColor
    indicatorLayer.fillColor = nil;
    indicatorLayer.opaque = NO;
    indicatorLayer.hidden = YES;
    indicatorLayer.bounds = ctdCGRectMake(CGPointZero, layerSize);

    UIBezierPath* indicatorPath =
        [UIBezierPath bezierPathWithOvalInRect:indicatorLayer.bounds];
    ctdPerformWithCopyOfPath(indicatorPath.CGPath, ^(CGPathRef path) {
        indicatorLayer.path = path;
    });

    return indicatorLayer;
}

@end




@implementation CTDUIKitDotView
{
    CTDUIKitColorPalette* _colorPalette;
    // Copy of parent's layer property, cast to the correct type (for convenience).
    __unsafe_unretained CAShapeLayer* _dotLayer;
    CAShapeLayer* _selectionIndicatorLayer;
}



#pragma mark Initialization


+ (void)initialize
{
    if (self == [CTDUIKitDotView class]) {
        kSelectionIndicatorColor = [[UIColor purpleColor] CGColor];  // should come from DrawingConfig
    }
}

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
        _colorPalette = colorPalette;

        _dotLayer = (CAShapeLayer*)self.layer;
        _dotLayer.lineWidth = 0;
        _dotLayer.opaque = NO;
        _dotLayer.fillColor = [colorPalette[dotColor] CGColor];

        CGPathRef dotPath = CGPathCreateWithEllipseInRect(_dotLayer.bounds, NULL);
        _dotLayer.path = dotPath;
        CGPathRelease(dotPath);

        CGFloat const padding = kSelectionIndicatorPadding;
        CGSize selectionIndicatorSize = ctdCGSizeAdd(_dotLayer.bounds.size,
                                                     padding * 2.0, padding * 2.0);

        _selectionIndicatorLayer = [CTDUIKitDotViewSelectionIndicatorFactory
                                    indicatorLayerWithSize:selectionIndicatorSize];
        [_dotLayer addSublayer:_selectionIndicatorLayer];
        _selectionIndicatorLayer.position = ctdCGRectCenter(_dotLayer.bounds);

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
    withoutImplicitAnimationDo(^{
        CGRect minimizedRect = CGRectInset(_selectionIndicatorLayer.bounds,
                                           kSelectionIndicatorPadding - 1,
                                           kSelectionIndicatorPadding - 1);
        UIBezierPath* startPath = [UIBezierPath bezierPathWithOvalInRect:minimizedRect];

        [CTDUIKitAnimator animateShapeLayer:_selectionIndicatorLayer
                           fromStartingPath:startPath.CGPath
                               toEndingPath:_selectionIndicatorLayer.path
                                forDuration:kSelectionAnimationDuration];
        _selectionIndicatorLayer.hidden = NO;
    });
}

- (void)hideSelectionIndicator
{
    withoutImplicitAnimationDo(^{
        CGRect minimizedRect = CGRectInset(_selectionIndicatorLayer.bounds,
                                           kSelectionIndicatorPadding - 1,
                                           kSelectionIndicatorPadding - 1);
        UIBezierPath* endPath = [UIBezierPath bezierPathWithOvalInRect:minimizedRect];

        [CTDUIKitAnimator animateShapeLayer:_selectionIndicatorLayer
                           fromStartingPath:_selectionIndicatorLayer.path
                               toEndingPath:endPath.CGPath
                                forDuration:kSelectionAnimationDuration];
        _selectionIndicatorLayer.hidden = YES;
    });
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
