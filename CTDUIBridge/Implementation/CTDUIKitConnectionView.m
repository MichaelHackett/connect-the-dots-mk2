// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectionView.h"

#import "CTDCoreGraphicsUtils.h"
#import "CTDPoint+CGConversion.h"



static CGFloat kDefaultLineWidth = 1.0;




@implementation CTDUIKitConnectionView
{
    CGPoint _firstEndpoint;
    CGPoint _secondEndpoint;
    // Copy of parent's layer property, cast to the correct type (for convenience).
    __unsafe_unretained CAShapeLayer* _lineLayer;
}

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

// layer's anchor point is (0,1)? (top-left)

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _firstEndpoint = CGPointZero;
        _secondEndpoint = CGPointZero;
        _lineColor = [UIColor whiteColor];
        _lineLayer = (CAShapeLayer*)self.layer;
//        _lineLayer.anchorPoint = CGPointMake(0.0, 0.0);
        _lineLayer.lineCap = kCALineCapRound;
        _lineLayer.lineWidth = kDefaultLineWidth;
        _lineLayer.opaque = NO;
        _lineLayer.strokeColor = [_lineColor CGColor];
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD

// Automatically resize to match the parent view's bounds.
- (void)willMoveToSuperview:(UIView*)newSuperview
{
    [self setFrame:newSuperview.bounds];
}



#pragma mark Property accessors


- (void)setLineColor:(UIColor*)lineColor
{
    _lineColor = [lineColor copy];
    _lineLayer.strokeColor = [_lineColor CGColor];
}

- (CGFloat)lineWidth
{
    return _lineLayer.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineLayer.lineWidth = lineWidth;
}



#pragma mark CTDDotConnectionRenderer protocol


- (void)setFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
{
    _firstEndpoint = [firstEndpointPosition asCGPoint];
    [self CTDUIKitConnectionView_refreshPath];
}

- (void)setSecondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    _secondEndpoint = [secondEndpointPosition asCGPoint];
    [self CTDUIKitConnectionView_refreshPath];
}

- (void)invalidate
{
    [self removeFromSuperview];
}



#pragma mark Internal methods


- (void)CTDUIKitConnectionView_refreshPath
{
    UIBezierPath* line = [[UIBezierPath alloc] init];
    [line moveToPoint:_firstEndpoint];
    [line addLineToPoint:_secondEndpoint];
    ctdPerformWithCopyOfPath([line CGPath], ^(CGPathRef pathCopy) {
        // path is not implicitly animated, so just update it
        _lineLayer.path = pathCopy;
    });
    // no need to do an explicit refresh either; path changes are immediately redrawn
}

@end
