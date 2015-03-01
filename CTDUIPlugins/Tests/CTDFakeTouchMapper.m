// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDFakeTouchMapper.h"



@implementation CTDFakeTouchMapper
{
    NSDictionary* _pointToElementMap;
}

- (instancetype)initWithPointMap:(NSDictionary*)pointToElementMap
{
    self = [super init];
    if (self) {
        _pointToElementMap = [pointToElementMap copy];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (id)elementAtTouchLocation:(CTDPoint*)touchLocation
{
    return [_pointToElementMap objectForKey:touchLocation];
}

@end
