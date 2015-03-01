// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDFakeDotRenderer.h"

#import "CTDUtility/CTDPoint.h"



@implementation CTDFakeDotRenderer
{
    NSMutableArray* _colorChanges;
}

- (instancetype)initWithCenterPosition:(CTDPoint*)centerPosition
                              dotColor:(CTDPaletteColor)dotColor
{
    self = [super init];
    if (self) {
        _centerPosition = [centerPosition copy];
        _colorChanges = [[NSMutableArray alloc] init];
        [_colorChanges addObject:@(dotColor)];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (NSArray*)colorChanges
{
    return [_colorChanges copy];
}



#pragma mark CTDDotRenderer protocol


- (CTDPoint*)connectionPoint
{
    return self.centerPosition;
}

- (void)changeDotColorTo:(CTDPaletteColor)newDotColor
{
    [_colorChanges addObject:@(newDotColor)];
}



#pragma mark CTDTouchable protocol


- (BOOL)containsTouchLocation:(__unused CTDPoint*)touchLocation
{
    return NO;
}

@end
