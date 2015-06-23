// Copyright 2013-5 Michael Hackett. All rights reserved.

#import "CTDUIKitDotView.h"

#import "CTDAnimationUtils.h"
#import "CTDCoreGraphicsUtils.h"
#import "CTDUIKitAnimator.h"
#import "CTDUIKitColorPalette.h"
#import <QuartzCore/CAShapeLayer.h>


// Additional default display parameters (see layer factory methods for others):
static CGFloat const kDefaultDotScale = 0.5;
static CGFloat const kDefaultSelectionAnimationDuration = (CGFloat)0.12;




@implementation CTDUIKitDotView
{
    CAShapeLayer* _dotLayer;
    CAShapeLayer* _selectionIndicatorLayer;
}



#pragma mark Initialization


// These factory methods define the default states for each of the elements of
// the view. The configuration steps serve the same purpose as constant
// declarations (since the values are never used outside of this method), so
// there is no real value in making separate definitions above.
//
// It is possible to override these in subclasses (the initializer will call
// the version of the actual class being instantiated), if necessary to achieve
// some effect, however, they are not currently exposed as public methods.

+ (CAShapeLayer*)dotLayerWithSize:(CGSize)layerSize
{
    CAShapeLayer* newLayer = [CAShapeLayer layer];
    newLayer.name = @"Dot";
    newLayer.lineWidth = 0;
    newLayer.fillColor = [[UIColor whiteColor] CGColor]; //dotColor;
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
    newLayer.name = @"Selection indicator";
    newLayer.lineWidth = 1.0;
    newLayer.strokeColor = [[UIColor whiteColor] CGColor];
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
        _selectionAnimationDuration = kDefaultSelectionAnimationDuration;

        CGSize dotSize = CGSizeMake(frameRect.size.width * kDefaultDotScale,
                                    frameRect.size.height * kDefaultDotScale);
        _dotLayer = [[self class] dotLayerWithSize:dotSize];
        [self.layer addSublayer:_dotLayer];
        _dotLayer.position = ctdCGRectCenter(self.layer.bounds);

        _selectionIndicatorLayer = [[self class] indicatorLayerWithSize:frameRect.size];
        _selectionIndicatorLayer.hidden = YES;
        [self.layer addSublayer:_selectionIndicatorLayer];
        _selectionIndicatorLayer.position = ctdCGRectCenter(self.layer.bounds);
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

- (CGFloat)dotScale
{
    return _dotLayer.frame.size.height / self.layer.bounds.size.height;
}

- (void)setDotScale:(CGFloat)dotScale
{
    CGRect dotBounds = _dotLayer.bounds;
    dotBounds.size.width = self.bounds.size.width * dotScale;
    dotBounds.size.height = self.bounds.size.height * dotScale;
    _dotLayer.bounds = dotBounds;

    CGPathRef dotPath = CGPathCreateWithEllipseInRect(dotBounds, NULL);
    _dotLayer.path = dotPath;
    CGPathRelease(dotPath);
}

// TODO: Watch View's frame (or its layer's frame) and adjust dot layer size, path, and selection indicator path

- (UIColor*)selectionIndicatorColor
{
    return [UIColor colorWithCGColor:_selectionIndicatorLayer.strokeColor];
}

- (void)setSelectionIndicatorColor:(UIColor*)selectionIndicatorColor
{
    _selectionIndicatorLayer.strokeColor = [selectionIndicatorColor CGColor];
}

- (CGFloat)selectionIndicatorThickness
{
    return _selectionIndicatorLayer.lineWidth;
}

- (void)setSelectionIndicatorThickness:(CGFloat)selectionIndicatorThickness
{
    _selectionIndicatorLayer.lineWidth = selectionIndicatorThickness;
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

    CGRect dotRect = [_selectionIndicatorLayer convertRect:_dotLayer.bounds fromLayer:_dotLayer];
    CGRect minimizedRect = CGRectInset(dotRect, -1, -1);
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
                                forDuration:self.selectionAnimationDuration];
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
