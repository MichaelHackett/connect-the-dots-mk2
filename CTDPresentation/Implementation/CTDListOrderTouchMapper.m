// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDListOrderTouchMapper.h"

#import "CTDTouchable.h"



@implementation CTDListOrderTouchMapper
{
    NSMutableArray* _touchables;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _touchables = [[NSMutableArray alloc] init];
    }
    return self;
}



#pragma mark - Touchables list maintenance


- (void)appendTouchable:(id<CTDTouchable>)touchableElement
{
    [_touchables addObject:touchableElement];
}

// TODO --- when needed
//- (void)insertTouchable:(id<CTDTouchable>)newTouchableElement
//           afterElement:(id<CTDTouchable>)referenceElement
//{
//
//}

- (void)removeTouchable:(id<CTDTouchable>)touchableElement
{
    [_touchables removeObject:touchableElement];
}



#pragma mark - CTDTouchable protocol


- (id)elementAtTouchLocation:(CTDPoint*)touchLocation
{
    for (id<CTDTouchable> touchTarget in _touchables) {
        if ([touchTarget containsTouchLocation:touchLocation]) {
            return touchTarget;
        }
    }
    return nil;
}

@end
