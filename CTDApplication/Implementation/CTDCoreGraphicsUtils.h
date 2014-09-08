// CoreGraphics supplementary utility functions.
//
// Copyright 2013-4 Michael Hackett. All rights reserved.

#ifndef ConnectTheDots_CTDCoreGraphicsUtils_h
#define ConnectTheDots_CTDCoreGraphicsUtils_h

#include <CoreGraphics/CGAffineTransform.h>
#include <CoreGraphics/CGGeometry.h>
#include <CoreGraphics/CGPath.h>

//extern CGRect ctdCGRectUnit;

CGSize ctdCGSizeAdd(CGSize size, CGFloat width, CGFloat height);
CGPoint ctdCGRectCenter(CGRect rect);
CGRect ctdCGRectMake(CGPoint origin, CGSize size);

CGAffineTransform ctdCGAffineTransformScaleAroundPoint(CGFloat scaleX,
                                                       CGFloat scaleY,
                                                       CGPoint anchorPoint);

CGPathRef ctdCGPathCreateScaledCopy(CGPathRef path,
                                    CGFloat scaleX,
                                    CGFloat scaleY,
                                    CGPoint anchorPoint);

void ctdPerformWithCopyOfPath(CGPathRef path, void (^block)(CGPathRef pathCopy));

#endif
