// Copyright 2015 Michael Hackett. All rights reserved.

#import "NSArray+CTDAdditions.h"



@interface NSArrayAdditionsNumberListCreationTests : XCTestCase
@end

@implementation NSArrayAdditionsNumberListCreationTests

- (void)testThatListHasSingleElementWhenStartAndEndOfRangeAreEqual
{
    assertThat([NSArray ctd_arrayOfIntegersFrom:4 to:4],
               is(equalTo(@[ @4 ])));
}

- (void)testThatTheListContainsAllTheIntegersWithinTheGivenRangeInAscendingOrderWhenStartIsLessThanEnd
{
    assertThat([NSArray ctd_arrayOfIntegersFrom:93 to:105],
               is(equalTo(@[ @93, @94, @95, @96, @97, @98, @99, @100, @101, @102, @103, @104, @105 ])));
}

- (void)testThatTheListContainsAllTheIntegersWithinTheGivenRangeInDescendingOrderWhenEndIsLessThanStart
{
    assertThat([NSArray ctd_arrayOfIntegersFrom:9 to:-5],
               is(equalTo(@[ @9, @8, @7, @6, @5, @4, @3, @2, @1, @0, @-1, @-2, @-3, @-4, @-5 ])));
}

@end

