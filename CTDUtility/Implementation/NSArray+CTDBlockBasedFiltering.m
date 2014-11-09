// Copyright 2014 Michael Hackett. All rights reserved.

#import "NSArray+CTDBlockBasedFiltering.h"



@implementation NSArray (CTDBlockBasedFiltering)

- (NSArray*)filteredArrayUsingTest:
                (BOOL (^)(id obj, NSUInteger index, BOOL* stop))predicate
{
    NSIndexSet* matchingIndexes =
        [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger index, BOOL* stop)
    {
        return predicate(obj, index, stop);
    }];
    return [self objectsAtIndexes:matchingIndexes];
}

@end
