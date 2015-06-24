// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectionView.h"

#import "CTDCoreGraphicsUtils.h"



static CGFloat kDefaultLineWidth = 1.0;




@implementation CTDUIKitConnectionView
{
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
        _lineLayer.lineCap = kCALineCapRound;
        _lineLayer.lineWidth = kDefaultLineWidth;
        _lineLayer.opaque = NO;
        _lineLayer.strokeColor = [_lineColor CGColor];
    }
    return self;
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

- (void)setFirstEndpoint:(CGPoint)firstEndpoint
{
    _firstEndpoint = firstEndpoint;
    [self CTDUIKitConnectionView_refreshPath];
}

- (void)setSecondEndpoint:(CGPoint)secondEndpoint
{
    _secondEndpoint = secondEndpoint;
    [self CTDUIKitConnectionView_refreshPath];
}



#pragma mark Internal methods


- (void)CTDUIKitConnectionView_refreshPath
{
    UIBezierPath* line = [[UIBezierPath alloc] init];
    [line moveToPoint:_firstEndpoint];
    [line addLineToPoint:_secondEndpoint];
    ctdPerformWithCopyOfPath([line CGPath], ^(CGPathRef pathCopy) {
        // path is not implicitly animated, so just update it
        self->_lineLayer.path = pathCopy;
    });
    // no need to do an explicit refresh either; path changes are immediately redrawn
}

@end
