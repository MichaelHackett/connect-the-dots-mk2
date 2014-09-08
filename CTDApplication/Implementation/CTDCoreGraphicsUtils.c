// Copyright 2013-4 Michael Hackett. All rights reserved.

#include "CTDCoreGraphicsUtils.h"

// The "unit" (1x1) rectangle.
// Not currently used.
//CGRect ctdCGRectUnit = (CGRect){ {0.0, 0.0}, {1.0, 1.0} };

CGSize ctdCGSizeAdd(CGSize size, CGFloat width, CGFloat height)
{
    return CGSizeMake(size.width + width, size.height + height);
}

CGPoint ctdCGRectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGRect ctdCGRectMake(CGPoint origin, CGSize size)
{
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

CGAffineTransform ctdCGAffineTransformScaleAroundPoint(CGFloat scaleX,
                                                       CGFloat scaleY,
                                                       CGPoint anchorPoint)
{
    CGAffineTransform shifted =
        CGAffineTransformMakeTranslation(anchorPoint.x, anchorPoint.y);
    CGAffineTransform shiftedAndScaled =
        CGAffineTransformScale(shifted, scaleX, scaleY);
    CGAffineTransform shiftedBack =
        CGAffineTransformTranslate(shiftedAndScaled,
                                   -anchorPoint.x,
                                   -anchorPoint.y);
    return shiftedBack;
}

CGPathRef ctdCGPathCreateScaledCopy(CGPathRef path,
                                    CGFloat scaleX,
                                    CGFloat scaleY,
                                    CGPoint anchorPoint)
{
    CGAffineTransform transform =
        ctdCGAffineTransformScaleAroundPoint(scaleX, scaleY, anchorPoint);

    return CGPathCreateCopyByTransformingPath(path, &transform);
}

void ctdPerformWithCopyOfPath(CGPathRef originalPath,
                              void (^block)(CGPathRef pathCopy))
{
    CGPathRef pathCopy = CGPathCreateCopy(originalPath);
    block(pathCopy);
    CFRelease(pathCopy);
}

