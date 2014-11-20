// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDDot.h"

#import "CTDUtility/CTDPoint.h"




@implementation CTDDot

- (instancetype)initWithColor:(CTDDotColor)color
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
