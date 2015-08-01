// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectTheDotsView.h"

#import "CTDUIKitDotView.h"
#import "CTDUIKitLineView.h"


static NSString* const kDotDiameterKey = @"CTDUIKitConnectTheDotsView_dotDiameter";
static NSString* const kDotSelectionIndicatorColorKey = @"CTDUIKitConnectTheDotsView_dotSelectionIndicatorColor";
static NSString* const kDotSelectionIndicatorThicknessKey = @"CTDUIKitConnectTheDotsView_dotSelectionIndicatorThickness";
static NSString* const kDotSelectionIndicatorPaddingKey = @"CTDUIKitConnectTheDotsView_dotSelectionIndicatorPadding";
static NSString* const kDotSelectionAnimationDurationKey = @"CTDUIKitConnectTheDotsView_dotSelectionAnimationDuration";
static NSString* const kConnectionLineWidthKey = @"CTDUIKitConnectTheDotsView_connectionLineWidth";
static NSString* const kConnectionLineColorKey = @"CTDUIKitConnectTheDotsView_connectionLineColor";



@implementation CTDUIKitConnectTheDotsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dotDiameter = 0;
        _dotSelectionIndicatorColor = [UIColor whiteColor];
        _dotSelectionIndicatorThickness = 1;
        _dotSelectionIndicatorPadding = 0;
        _dotSelectionAnimationDuration = (CGFloat)0.12;
        _connectionLineWidth = 1;
        _connectionLineColor = [UIColor whiteColor];
    }
    return self;
}



#pragma mark NSCoder protocol


- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        _dotDiameter = [decoder decodeFloatForKey:kDotDiameterKey];
        _dotSelectionIndicatorColor = [decoder decodeObjectForKey:kDotSelectionIndicatorColorKey];
        _dotSelectionIndicatorThickness = [decoder decodeFloatForKey:kDotSelectionIndicatorThicknessKey];
        _dotSelectionIndicatorPadding = [decoder decodeFloatForKey:kDotSelectionIndicatorPaddingKey];
        _dotSelectionAnimationDuration = [decoder decodeFloatForKey:kDotSelectionAnimationDurationKey];
        _connectionLineWidth = [decoder decodeFloatForKey:kConnectionLineWidthKey];
        _connectionLineColor = [decoder decodeObjectForKey:kConnectionLineColorKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    [super encodeWithCoder:coder];
    [coder encodeFloat:self.dotDiameter forKey:kDotDiameterKey];
    [coder encodeObject:_dotSelectionIndicatorColor forKey:kDotSelectionIndicatorColorKey];
    [coder encodeFloat:self.dotSelectionIndicatorThickness forKey:kDotSelectionIndicatorThicknessKey];
    [coder encodeFloat:self.dotSelectionIndicatorPadding forKey:kDotSelectionIndicatorPaddingKey];
    [coder encodeFloat:self.dotSelectionAnimationDuration forKey:kDotSelectionAnimationDurationKey];
    [coder encodeFloat:self.connectionLineWidth forKey:kConnectionLineWidthKey];
    [coder encodeObject:self.connectionLineColor forKey:kConnectionLineColorKey];
}



#pragma mark Subview creation


- (CGRect)CTDUIKitConnectTheDotsView_frameForDotCenteredAt:(CGPoint)center
{
    CGFloat radius = self.dotDiameter / (CGFloat)2.0 + self.dotSelectionIndicatorPadding;
    CGFloat left = center.x - radius;
    CGFloat top = center.y - radius;
    return CGRectMake(left, top, radius * 2, radius * 2);
}

- (CTDUIKitDotView*)newDotCenteredAt:(CGPoint)center
{
    CTDUIKitDotView* newDotView =
        [[CTDUIKitDotView alloc]
         initWithFrame:[self CTDUIKitConnectTheDotsView_frameForDotCenteredAt:center]];
    newDotView.dotScale = self.dotDiameter / newDotView.frame.size.height;
    newDotView.selectionIndicatorColor = self.dotSelectionIndicatorColor;
    newDotView.selectionIndicatorThickness = self.dotSelectionIndicatorThickness;
    newDotView.selectionAnimationDuration = self.dotSelectionAnimationDuration;
    [self addSubview:newDotView];

    return newDotView;
}

- (CTDUIKitLineView*)newConnection
{
    CTDUIKitLineView* lineView = [[CTDUIKitLineView alloc]
                                  initWithFrame:self.bounds];
    lineView.lineWidth = self.connectionLineWidth;
    lineView.lineColor = self.connectionLineColor;
    lineView.firstEndpoint = CGPointZero;
    lineView.secondEndpoint = CGPointZero;
    [self addSubview:lineView];

    return lineView;
}

@end
