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

static NSString* const kDotLayerName = @"Dot";
static NSString* const kSelectionIndicatorLayerName = @"Selection indicator";




@implementation CTDUIKitDotView
{
    CTDUIKitColorPalette* _colorPalette;
    CAShapeLayer* _dotLayer;
    CAShapeLayer* _selectionIndicatorLayer;
}



#pragma mark Initialization


+ (void)initialize
{
    if (self == [CTDUIKitDotView class]) {
        kSelectionIndicatorColor = [[UIColor purpleColor] CGColor];  // should come from DrawingConfig
    }
}

+ (CAShapeLayer*)dotLayerWithSize:(CGSize)layerSize
                            color:(CGColorRef)dotColor
{
    CAShapeLayer* newLayer = [CAShapeLayer layer];
    newLayer.name = kDotLayerName;
    newLayer.lineWidth = 0;
    newLayer.fillColor = dotColor;
    newLayer.strokeColor = nil;
    newLayer.opaque = NO;
    newLayer.bounds = ctdCGRectMake(CGPointZero, layerSize);

    CGPathRef dotPath = CGPathCreateWithEllipseInRect(newLayer.bounds, NULL);
    newLayer.path = dotPath;
    CGPathRelease(dotPath);

    return newLayer;
}

+ (CAShapeLayer*)indicatorLayerWithSize:(CGSize)layerSize
{
    CAShapeLayer* newLayer = [CAShapeLayer layer];
    newLayer.name = kSelectionIndicatorLayerName;
    newLayer.lineWidth = kSelectionIndicatorThickness;  // config.selectionIndicatorThickness
    newLayer.strokeColor = kSelectionIndicatorColor;  // config.selectionIndicatorColor
    newLayer.fillColor = nil;
    newLayer.opaque = NO;
    newLayer.bounds = ctdCGRectMake(CGPointZero, layerSize);

    CGPathRef indicatorPath = CGPathCreateWithEllipseInRect(newLayer.bounds, NULL);
    newLayer.path = indicatorPath;
    CGPathRelease(indicatorPath);

    return newLayer;
}

- (id)initWithFrame:(CGRect)frameRect
           dotColor:(CTDPaletteColorLabel)dotColor
       colorPalette:(CTDUIKitColorPalette*)colorPalette
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _colorPalette = colorPalette;

        CGSize dotSize = CGRectInset(frameRect,
                                     kSelectionIndicatorPadding,
                                     kSelectionIndicatorPadding).size;

        _dotLayer = [[self class] dotLayerWithSize:dotSize
                                             color:[colorPalette[dotColor] CGColor]];
        [self.layer addSublayer:_dotLayer];
        _dotLayer.position = ctdCGRectCenter(self.layer.bounds);

        CGFloat const padding = kSelectionIndicatorPadding;
        CGSize selectionIndicatorSize = ctdCGSizeAdd(_dotLayer.bounds.size,
                                                     padding * 2.0, padding * 2.0);

        _selectionIndicatorLayer = [[self class] indicatorLayerWithSize:selectionIndicatorSize];
        _selectionIndicatorLayer.hidden = YES;
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
    CGPoint localPoint = [_dotLayer convertPoint:[touchLocation asCGPoint]
                                       fromLayer:self.superview.layer];
    return (BOOL)CGPathContainsPoint(_dotLayer.path, NULL, localPoint, false);
}

@end
