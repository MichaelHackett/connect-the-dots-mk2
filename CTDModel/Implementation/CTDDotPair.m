// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDDotPair.h"

#import "CTDUtility/CTDPoint.h"



@implementation CTDDotPair

- (instancetype)initWithColor:(CTDDotColor)color
                startPosition:(CTDPoint*)startPosition
                  endPosition:(CTDPoint*)endPosition
{
    self = [super init];
    if (self) {
        _color = color;
        _startPosition = startPosition;
        _endPosition = endPosition;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

@end
