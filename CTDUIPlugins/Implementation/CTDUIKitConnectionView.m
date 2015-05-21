// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectionView.h"

#import "CTDCoreGraphicsUtils.h"
#import "CTDUIBridge/CTDPoint+CGConversion.h"




// Note: do not directly access the "path" property; use the subclass methods
// only. (Setting line properties, background color, etc., through
// the base CALayer classes is fine, however.)

@interface CTDUIKitLineLayer : CAShapeLayer

- (void)changeStartingPointTo:(CGPoint)newStartingPoint;
- (void)changeEndingPointTo:(CGPoint)newEndingPoint;

@end




@implementation CTDUIKitConnectionView
{
    CGPoint _firstEndpoint;
    CGPoint _secondEndpoint;
    UIColor* _lineColor;
}

+ (Class)layerClass
{
    return [CTDUIKitLineLayer class];
}

// layer's anchor point is (0,1)? (top-left)

- (instancetype)initWithLineWidth:(CGFloat)lineWidth
                        lineColor:(UIColor*)lineColor
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _firstEndpoint = CGPointZero;
        _secondEndpoint = CGPointZero;
        _lineColor = [lineColor copy];  // need to retain UIColor while using its CGColor field
        CTDUIKitLineLayer* viewLayer = (CTDUIKitLineLayer*)self.layer;
//        viewLayer.anchorPoint = CGPointMake(0.0, 0.0);
        viewLayer.lineCap = kCALineCapRound;
        viewLayer.lineWidth = lineWidth;
        viewLayer.opaque = NO;
        viewLayer.strokeColor = [_lineColor CGColor];
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD

// Automatically resize to match the parent view's bounds.
- (void)willMoveToSuperview:(UIView*)newSuperview
{
    [self setFrame:newSuperview.bounds];
}



#pragma mark CTDDotConnectionRenderer protocol


- (void)setFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
{
    [(CTDUIKitLineLayer*)self.layer
            changeStartingPointTo:[firstEndpointPosition asCGPoint]];
}

- (void)setSecondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    [(CTDUIKitLineLayer*)self.layer
            changeEndingPointTo:[secondEndpointPosition asCGPoint]];
}

- (void)invalidate
{
    [self removeFromSuperview];
}

@end





@implementation CTDUIKitLineLayer
{
    CGPoint _startingPoint;
    CGPoint _endingPoint;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _startingPoint = CGPointZero;
        _endingPoint = CGPointZero;
    }
    return self;
}

- (void)changeStartingPointTo:(CGPoint)newStartingPoint
{
    _startingPoint = newStartingPoint;
    [self CTDUIKitLineLayer_refreshPath];
}

- (void)changeEndingPointTo:(CGPoint)newEndingPoint
{
    _endingPoint = newEndingPoint;
    [self CTDUIKitLineLayer_refreshPath];
}

- (void)CTDUIKitLineLayer_refreshPath
{
    UIBezierPath* line = [[UIBezierPath alloc] init];
    [line moveToPoint:_startingPoint];
    [line addLineToPoint:_endingPoint];
    ctdPerformWithCopyOfPath([line CGPath], ^(CGPathRef pathCopy) {
        // path is not implicitly animated, so just update it
        self.path = pathCopy;
    });
    // no need to do an explicit refresh either; path changes are immediately redrawn
}

@end
