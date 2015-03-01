// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDIntegerQuantity.h"


@interface CTDIntegerQuantityTests : XCTestCase
@end

@implementation CTDIntegerQuantityTests

- (void)testDescriptionUsesSingularUnitWhenMagnitudeEqualsOne
{
    CTDIntegerQuantity* subject = [[CTDIntegerQuantity alloc]
                                   initWithMagnitude:1
                                        unitSingular:@"mouse"
                                          unitPlural:@"mice"];
    assertThat([subject description], is(equalTo(@"1 mouse")));
}

- (void)testDescriptionUsesPluralUnitWhenMagnitudeEqualsZero
{
    CTDIntegerQuantity* subject = [[CTDIntegerQuantity alloc]
                                   initWithMagnitude:0
                                        unitSingular:@"mouse"
                                          unitPlural:@"mice"];
    assertThat([subject description], is(equalTo(@"0 mice")));
}

- (void)testDescriptionUsesPluralUnitWhenMagnitudeEqualsTwo
{
    CTDIntegerQuantity* subject = [[CTDIntegerQuantity alloc]
                                   initWithMagnitude:2
                                        unitSingular:@"mouse"
                                          unitPlural:@"mice"];
    assertThat([subject description], is(equalTo(@"2 mice")));
}

- (void)testDescriptionUsesPluralUnitWhenMagnitudeEqualsTen
{
    CTDIntegerQuantity* subject = [[CTDIntegerQuantity alloc]
                                   initWithMagnitude:10
                                        unitSingular:@"mouse"
                                          unitPlural:@"mice"];
    assertThat([subject description], is(equalTo(@"10 mice")));
}

- (void)testDefaultPluralIsSingularUnitPlusS
{
    CTDIntegerQuantity* subject = [[CTDIntegerQuantity alloc]
                                   initWithMagnitude:10
                                                unit:@"mouse"];
    assertThat([subject description], is(equalTo(@"10 mouses")));
}

@end
