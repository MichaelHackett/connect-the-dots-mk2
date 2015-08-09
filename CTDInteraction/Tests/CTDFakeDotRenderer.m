// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDFakeDotRenderer.h"

#import "CTDUtility/CTDPoint.h"



@implementation CTDFakeDotRenderer
{
    NSMutableArray* _colorChanges;
}

- (instancetype)initWithCenterPosition:(CTDPoint*)centerPosition
                              dotColor:(CTDPaletteColorLabel)dotColor
{
    self = [super init];
    if (self) {
        _centerPosition = [centerPosition copy];
        _colorChanges = [[NSMutableArray alloc] init];
        [_colorChanges addObject:dotColor];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (NSArray*)colorChanges
{
    return [_colorChanges copy];
}



#pragma mark CTDDotRenderer protocol


- (CTDPoint*)dotConnectionPoint
{
    return self.centerPosition;
}

- (void)setDotColor:(CTDPaletteColorLabel)newDotColor
{
    [_colorChanges addObject:newDotColor];
}



#pragma mark CTDSelectionRenderer protocol


- (void)showSelectionIndicator
{
    [self recordMessageWithSelector:_cmd];
}

- (void)hideSelectionIndicator
{
    [self recordMessageWithSelector:_cmd];
}



#pragma mark CTDTouchable protocol


- (BOOL)containsTouchLocation:(__unused CTDPoint*)touchLocation
{
    return NO;
}

@end
