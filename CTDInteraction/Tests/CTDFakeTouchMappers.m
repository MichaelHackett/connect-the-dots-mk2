// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDFakeTouchMappers.h"



@implementation CTDFakeTouchToElementMapper
{
    NSDictionary* _pointToElementMap;
}

- (instancetype)initWithPointMap:(NSDictionary*)pointToElementMap
{
    self = [super init];
    if (self)
    {
        _pointToElementMap = [pointToElementMap copy];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (id)idOfElementAtTouchLocation:(CTDPoint*)touchLocation
{
    return [_pointToElementMap objectForKey:touchLocation];
}

@end





@implementation CTDFakeTouchToPointMapper
{
    NSDictionary* _pointToPointMap;
}

- (instancetype)initWithPointMap:(NSDictionary*)pointToPointMap
{
    self = [super init];
    if (self)
    {
        _pointToPointMap = [pointToPointMap copy];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (CTDPoint*)pointAtTouchLocation:(CTDPoint*)touchLocation
{
    return [_pointToPointMap objectForKey:touchLocation];
}

@end
