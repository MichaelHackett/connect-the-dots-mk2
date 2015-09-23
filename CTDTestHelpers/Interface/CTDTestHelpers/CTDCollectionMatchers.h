// CTDCollectionMatchers:
//     Additional matchers for collections, notably most taking arrays of
//     values or matchers, rather than varargs.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import <OCHamcrest/HCIsCollectionContainingInOrder.h>
#import <OCHamcrest/HCIsCollectionContainingInAnyOrder.h>


// Like 'contains' but accepts an array of matchers, instead of varargs.
// (Useful when the number of elements isn't fixed, or you don't want to have
// to explicitly list each one.)
#define matchesArray(matchers) [HCIsCollectionContainingInOrder isCollectionContainingInOrder:(matchers)]
#define matchesArrayInAnyOrder(matchers) [HCIsCollectionContainingInAnyOrder isCollectionContainingInAnyOrder:(matchers)]


// Verify that one collection contains references to the same instances as the given array.
id CTD_containsSameInstancesAs(NSArray* instances);
id CTD_containsInAnyOrderSameInstancesAs(NSArray* instances);

#ifdef HC_SHORTHAND
#define containsSameInstancesAs CTD_containsSameInstancesAs
#define containsInAnyOrderSameInstancesAs CTD_containsInAnyOrderSameInstancesAs
#endif
