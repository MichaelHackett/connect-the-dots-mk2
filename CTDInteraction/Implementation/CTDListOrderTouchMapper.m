// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDListOrderTouchMapper.h"

#import "Ports/CTDTouchable.h"



// TODO: Pull out into separate file

// An NSDictionary-like collection that allows entity types (instances that
// do not support NSCopying) as keys. All key matching is done by identity;
// that is, the key must be the same object at the same memory address in order
// to match.
//
// Note that the collection holds a strong references to the values added to
// it, but not to the keys. That could be changed if necessary, but for now,
// we're assuming that clients will be storing the keys in some other
// collection, and that collection will be responsible for retaining the key
// objects.

@interface CTDEntityKeyedDictionary : NSObject

- (id)objectForKey:(id)key;
- (void)setObject:(id)object forKey:(id)key;
- (void)removeObjectForKey:(id)key;

@end


static id keyFromEntity(id entity)
{
    return [NSValue valueWithNonretainedObject:entity];
}



@implementation CTDEntityKeyedDictionary
{
    NSMutableDictionary* _dictionary;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)objectForKey:(id)key
{
    return [_dictionary objectForKey:keyFromEntity(key)];
}

- (void)setObject:(id)object forKey:(id)key
{
    [_dictionary setObject:object forKey:keyFromEntity(key)];
}

- (void)removeObjectForKey:(id)key
{
    [_dictionary removeObjectForKey:keyFromEntity(key)];
}

@end





@implementation CTDListOrderTouchMapper
{
    NSMutableArray* _touchables;
    CTDEntityKeyedDictionary* _touchableToIdMap;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _touchables = [[NSMutableArray alloc] init];
        _touchableToIdMap = [[CTDEntityKeyedDictionary alloc] init];
    }
    return self;
}



#pragma mark Touchables list maintenance


- (void)mapTouchable:(id<CTDTouchable>)touchableElement
                toId:(id)elementId
{
    [_touchableToIdMap setObject:elementId forKey:touchableElement];
    [_touchables addObject:touchableElement];
}

- (void)unmapTouchable:(id<CTDTouchable>)touchableElement
{
    [_touchables removeObject:touchableElement];
    [_touchableToIdMap removeObjectForKey:touchableElement];
}

// TODO --- when needed
//- (void)insertTouchable:(id<CTDTouchable>)newTouchableElement
//           afterElement:(id<CTDTouchable>)referenceElement
//{
//
//}



#pragma mark CTDTouchToElementMapper protocol


- (id)idOfElementAtTouchLocation:(CTDPoint*)touchLocation
{
    for (id<CTDTouchable> touchTarget in _touchables) {
        if ([touchTarget containsTouchLocation:touchLocation]) {
            return [_touchableToIdMap objectForKey:touchTarget];
        }
    }
    return nil;
}

@end
