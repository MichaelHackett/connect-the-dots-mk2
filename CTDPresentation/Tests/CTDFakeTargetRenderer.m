// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDFakeTargetRenderer.h"

#import "CTDUtility/CTDPoint.h"



@implementation CTDFakeTargetRenderer

- (instancetype)initWithCenterPosition:(CTDPoint*)centerPosition
{
    self = [super init];
    if (self) {
        _centerPosition = [centerPosition copy];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (CTDPoint*)connectionPoint { return self.centerPosition; }
- (BOOL)containsTouchLocation:(__unused CTDPoint*)touchLocation { return NO; }

@end
