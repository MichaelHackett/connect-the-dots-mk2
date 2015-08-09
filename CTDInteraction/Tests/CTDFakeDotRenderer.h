// CTDFakeDotRenderer:
//     A test spy to stand in for a dot renderer.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "Ports/CTDTouchable.h"
#import "CTDApplication/Ports/CTDTrialRenderer.h"
#import "CTDTestHelpers/CTDTestSpy.h"

@class CTDPoint;



@interface CTDFakeDotRenderer : CTDTestSpy <CTDDotRenderer, CTDTouchable>

@property (copy, readonly, nonatomic) CTDPoint* centerPosition;
@property (copy, readonly, nonatomic) NSArray* colorChanges;

- (instancetype)initWithCenterPosition:(CTDPoint*)centerPosition
                              dotColor:(CTDPaletteColorLabel)dotColor;
CTD_NO_DEFAULT_INIT

@end
