// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDUIKitTargetView.h"

#import <QuartzCore/CAShapeLayer.h>



@implementation CTDUIKitTargetView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        CAShapeLayer* targetLayer = (CAShapeLayer*)self.layer;
        targetLayer.lineWidth = 0;
        targetLayer.opaque = NO;
        targetLayer.fillColor = [[UIColor redColor] CGColor];

        CGPathRef targetPath = CGPathCreateWithEllipseInRect(self.bounds, NULL);
        targetLayer.path = targetPath;
        CGPathRelease(targetPath);

        [targetLayer setNeedsDisplay];
    }
    return self;
}

@end
