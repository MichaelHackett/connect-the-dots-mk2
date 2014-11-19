// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTarget.h"

#import "CTDUtility/CTDPoint.h"




@implementation CTDTarget

- (instancetype)initWithColor:(CTDTargetColor)color
       position:(CTDPoint*)position;
{
    self = [super init];
    if (self) {
        _color = color;
        _position = [position copy];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

@end
