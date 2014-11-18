// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDFakeTargetRenderer.h"

#import "CTDUtility/CTDPoint.h"



@implementation CTDFakeTargetRenderer
{
    NSMutableArray* _colorChanges;
}

- (instancetype)initWithCenterPosition:(CTDPoint*)centerPosition
                           targetColor:(CTDPaletteColor)targetColor
{
    self = [super init];
    if (self) {
        _centerPosition = [centerPosition copy];
        _colorChanges = [[NSMutableArray alloc] init];
        [_colorChanges addObject:@(targetColor)];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (NSArray*)colorChanges
{
    return [_colorChanges copy];
}



#pragma mark CTDTargetRenderer protocol


- (CTDPoint*)connectionPoint
{
    return self.centerPosition;
}

- (void)changeTargetColorTo:(CTDPaletteColor)newTargetColor
{
    [_colorChanges addObject:@(newTargetColor)];
}



#pragma mark CTDTouchable protocol


- (BOOL)containsTouchLocation:(__unused CTDPoint*)touchLocation
{
    return NO;
}

@end
