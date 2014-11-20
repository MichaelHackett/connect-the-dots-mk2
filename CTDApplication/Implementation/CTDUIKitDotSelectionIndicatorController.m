// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDUIKitDotSelectionIndicatorController.h"

#import "CTDAnimationUtils.h"
#import "CTDCoreGraphicsUtils.h"
#import "CAAnimation+CTDAnimationConstruction.h"
#import "CALayer+CTDAnimationSupport.h"


// TODO: Move to CTDUIKitDrawingConfig

// Dot selection ring display parameters:
static CGColorRef kSelectionIndicatorColor;
static CGFloat const kSelectionIndicatorThickness = 3.0;
static CGFloat const kSelectionIndicatorPadding = 12.0;
static CGFloat const kSelectionAnimationDuration = (CGFloat)0.12;  // seconds
static NSString* const kSelectionIndicatorLayerName = @"Selection indicator";




// TODO: Maybe create two animation controllers, one for each effect. Then a
// single "perform" method acts as the trigger.

@interface CTDUIKitSelectionAnimationController : NSObject

- (id)initWithLayer:(CAShapeLayer*)animatedLayer;

CTD_NO_DEFAULT_INIT

- (void)showIndicator;
- (void)hideIndicator;

@end


@implementation CTDUIKitSelectionAnimationController
{
    CAShapeLayer* _layer;
    UIBezierPath* _minimizedPath;
    UIBezierPath* _maximizedPath;
}

- (id)initWithLayer:(CAShapeLayer*)layerToAnimate
{
    self = [super init];
    if (self) {
        _layer = layerToAnimate;
        CGRect maximizedBounds = layerToAnimate.bounds;
        CGRect minimizedBounds = CGRectInset(maximizedBounds,
                                             kSelectionIndicatorPadding,
                                             kSelectionIndicatorPadding);
        _minimizedPath = [UIBezierPath bezierPathWithOvalInRect:minimizedBounds];
        _maximizedPath = [UIBezierPath bezierPathWithOvalInRect:maximizedBounds];
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD

- (void)showIndicator
{
    withoutImplicitAnimationDo(^{
        [self performAnimationWithStartingPath:_minimizedPath.CGPath
                                    endingPath:_maximizedPath.CGPath];
        _layer.hidden = NO;
    });
}

- (void)hideIndicator
{
    withoutImplicitAnimationDo(^{
        [self performAnimationWithStartingPath:_maximizedPath.CGPath
                                    endingPath:_minimizedPath.CGPath];
        _layer.hidden = YES;
    });
}

// private method --- find another home?
- (void)performAnimationWithStartingPath:(CGPathRef)startingPath
                              endingPath:(CGPathRef)endingPath
{
    if ([_layer isAnimationInFlightForKeyPath:@"hidden"]) {
        startingPath = [(CAShapeLayer*)(_layer.presentationLayer) path];
    }

    CAAnimation* anim = [CAAnimation animationGroupContaining:@[
        [CAAnimation animationHoldingVisible],
        [CAAnimation animationOfPathFrom:startingPath to:endingPath]
    ] withDuration:kSelectionAnimationDuration];
    [_layer addAnimation:anim forKey:@"hidden"];
}

@end





@implementation CTDUIKitDotSelectionIndicatorController
{
    CAShapeLayer* _indicatorLayer;
    CTDUIKitSelectionAnimationController* _animationController;
}

+ (void)initialize
{
    if (self == [CTDUIKitDotSelectionIndicatorController class]) {
        kSelectionIndicatorColor = [[UIColor purpleColor] CGColor];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _indicatorLayer = [CAShapeLayer layer];
        _indicatorLayer.name = kSelectionIndicatorLayerName;
        _indicatorLayer.lineWidth = kSelectionIndicatorThickness;  // config.selectionIndicatorThickness
        _indicatorLayer.strokeColor = kSelectionIndicatorColor;  // config.selectionIndicatorColor
        _indicatorLayer.fillColor = nil;
        _indicatorLayer.opaque = NO;
        _indicatorLayer.hidden = YES;
    }
    return self;
}

- (void)dealloc
{
    [_indicatorLayer removeFromSuperlayer];
}

// TODO: Register to receive notifications when layer frame changes

- (void)attachIndicatorToLayer:(CALayer*)hostLayer;
{
    [hostLayer addSublayer:_indicatorLayer];
    [self refreshIndicatorFrame];
    _animationController = [[CTDUIKitSelectionAnimationController alloc]
                            initWithLayer:_indicatorLayer];
}

- (void)detachIndicator
{
    _animationController = nil;
    [_indicatorLayer removeFromSuperlayer];
}

// Remove from interface if we can get automatic notifications when the host
// layer changes size.
- (void)refreshIndicatorFrame
{
    CGFloat const padding = kSelectionIndicatorPadding;
    CGRect hostBounds = _indicatorLayer.superlayer.bounds;
    CGSize indicatorSize = ctdCGSizeAdd(hostBounds.size,
                                        padding * 2.0, padding * 2.0);

    CGRect indicatorBounds = ctdCGRectMake(CGPointZero, indicatorSize);
    _indicatorLayer.bounds = indicatorBounds;
    _indicatorLayer.position = ctdCGRectCenter(hostBounds);

    UIBezierPath* indicatorPath =
        [UIBezierPath bezierPathWithOvalInRect:indicatorBounds];
    ctdPerformWithCopyOfPath(indicatorPath.CGPath, ^(CGPathRef path) {
        _indicatorLayer.path = path;
    });
}

- (void)showIndicator
{
    [_animationController showIndicator];
}

- (void)hideIndicator
{
    [_animationController hideIndicator];
}

@end
