// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectionView.h"

#import "CTDCoreGraphicsUtils.h"
#import "CTDPoint+CGConversion.h"




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
}

+ (Class)layerClass
{
    return [CTDUIKitLineLayer class];
}

// layer's anchor point is (0,1)? (top-left)

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _firstEndpoint = CGPointZero;
        _secondEndpoint = CGPointZero;
        CTDUIKitLineLayer* viewLayer = (CTDUIKitLineLayer*)self.layer;
//        viewLayer.anchorPoint = CGPointMake(0.0, 0.0);
        viewLayer.lineCap = kCALineCapRound;
        viewLayer.lineWidth = 5.0;
        viewLayer.opaque = NO;
        viewLayer.strokeColor = [[UIColor yellowColor] CGColor];
    }
    return self;
}

// Automatically resize to match the parent view's bounds.
- (void)willMoveToSuperview:(UIView*)newSuperview
{
    [self setFrame:newSuperview.bounds];
}



#pragma mark - CTDTargetConnectionView protocol


- (void)setFirstEndpointPosition:(CTDPoint*)firstEndpoint
{
    [(CTDUIKitLineLayer*)self.layer
            changeStartingPointTo:[firstEndpoint asCGPoint]];
}

- (void)setSecondEndpointPosition:(CTDPoint*)secondEndpoint
{
    [(CTDUIKitLineLayer*)self.layer
            changeEndingPointTo:[secondEndpoint asCGPoint]];
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
