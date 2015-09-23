// Copyright 2015 Michael Hackett. All rights reserved.

#define HC_SHORTHAND 1

#import "CTDCollectionMatchers.h"

#import "CTDUtility/NSArray+CTDAdditions.h"
#import <OCHamcrest/HCIsSame.h>
#import <OCHamcrest/HCIs.h>



id CTD_containsSameInstancesAs(NSArray* instances)
{
    return matchesArray([instances ctd_map:^(id obj)
    {
        return is(sameInstance(obj));
    }]);
}

id CTD_containsInAnyOrderSameInstancesAs(NSArray* instances)
{
    return matchesArrayInAnyOrder([instances ctd_map:^(id obj)
    {
        return is(sameInstance(obj));
    }]);
}
