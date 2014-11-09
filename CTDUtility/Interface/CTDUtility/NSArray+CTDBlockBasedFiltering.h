// NSArray+CTDBlockBasedFiltering:
//     Adds a convenience method for producing a new array containing the
//     subset of elements passing a test specified in a block.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import <Foundation/NSArray.h>

@interface NSArray (CTDBlockBasedFiltering)

// The standard class includes a method for returning a set of indexes of
// elements matching some block, and another for returning a new array filtered
// using an NSPredicate (which can be created from a block), but it's a
// two-step process to achieve the desired result. This method simply takes
// the index set returned by `indexesOfObjectsWithOptions:passingTest:` and
// uses it to produce a new NSArray containing those elements in the index set.
//
- (NSArray*)filteredArrayUsingTest:
                (BOOL (^)(id obj, NSUInteger index, BOOL* stop))predicate;

@end
