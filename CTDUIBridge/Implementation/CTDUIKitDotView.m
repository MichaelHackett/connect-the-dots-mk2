// Copyright 2013-5 Michael Hackett. All rights reserved.

#import "CTDUIKitDotView.h"

#import "CTDAnimationUtils.h"
#import "CTDCoreGraphicsUtils.h"
#import "CTDUIKitAnimator.h"
#import "CTDUIKitColorPalette.h"
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
{
    self = [super initWithFrame:frameRect];
    if (self) {
        CGSize dotSize = CGRectInset(frameRect,
                                     kSelectionIndicatorPadding,
                                     kSelectionIndicatorPadding).size;

        _dotLayer = [[self class] dotLayerWithSize:dotSize
                                             color:[[UIColor whiteColor] CGColor]];
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




#pragma mark Property accessors


- (UIColor*)dotColor
{
    return [UIColor colorWithCGColor:_dotLayer.fillColor];
}

- (void)setDotColor:(UIColor*)dotColor
{
    _dotLayer.fillColor = dotColor.CGColor;
}

- (BOOL)selectionIndicatorIsVisible
{
    return !_selectionIndicatorLayer.hidden;
}

- (void)setSelectionIndicatorIsVisible:(BOOL)visible
{
    BOOL indicatorToBeHidden = !visible; // to make layer-state comparisons clearer
    if (indicatorToBeHidden == _selectionIndicatorLayer.hidden) {
        return;
    }

    CGRect minimizedRect = CGRectInset(_selectionIndicatorLayer.bounds,
                                       kSelectionIndicatorPadding - 1,
                                       kSelectionIndicatorPadding - 1);
    UIBezierPath* minimizedPath = [UIBezierPath bezierPathWithOvalInRect:minimizedRect];

    CGPathRef startPath;
    CGPathRef endPath;
    if (indicatorToBeHidden) {
        startPath = _selectionIndicatorLayer.path;
        endPath = minimizedPath.CGPath;
    } else {
        startPath = minimizedPath.CGPath;
        endPath = _selectionIndicatorLayer.path;
    }

    withoutImplicitAnimationDo(^{
        [CTDUIKitAnimator animateShapeLayer:_selectionIndicatorLayer
                           fromStartingPath:startPath
                               toEndingPath:endPath
                                forDuration:kSelectionAnimationDuration];
        _selectionIndicatorLayer.hidden = indicatorToBeHidden;
    });
}

- (CGPoint)connectionPoint
{
    return ctdCGRectCenter(self.frame);
}



#pragma mark Touch support


- (BOOL)containsTouchLocation:(CGPoint)touchLocation
{
    CGPoint localPoint = [_dotLayer convertPoint:touchLocation
                                       fromLayer:self.superview.layer];
    return (BOOL)CGPathContainsPoint(_dotLayer.path, NULL, localPoint, false);
}

@end
