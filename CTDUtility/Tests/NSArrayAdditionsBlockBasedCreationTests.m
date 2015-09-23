// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "NSArray+CTDAdditions.h"


// TODO: Rewrite tests in the form of NSArrayAdditionsNumberListCreationTests
// (and combine the files).


@interface CTDArrayAdditionsCreationFromBlockTestCase : XCTestCase
@property (strong, nonatomic) NSArray* result;
@end

@implementation CTDArrayAdditionsCreationFromBlockTestCase
@end




@interface CTDArrayAdditionsCreationFromBlockWhenBlockIsNil
    : CTDArrayAdditionsCreationFromBlockTestCase
@end

@implementation CTDArrayAdditionsCreationFromBlockWhenBlockIsNil

- (void)setUp
{
    [super setUp];
    self.result = [NSArray ctd_arrayWithSize:4 usingBlock:nil];
}

- (void)testThatReturnedArrayIsNotNil
{
    assertThat(self.result, isNot(nilValue()));
}

- (void)testThatReturnedArrayIsEmpty
{
    assertThat(self.result, hasCountOf(0));
}

@end





@interface CTDArrayAdditionsCreationFromBlockWhenCountIsZero
    : CTDArrayAdditionsCreationFromBlockTestCase
@end

@implementation CTDArrayAdditionsCreationFromBlockWhenCountIsZero

- (void)setUp
{
    [super setUp];
    self.result = [NSArray ctd_arrayWithSize:0
                                  usingBlock:^(__unused NSUInteger index)
    {
        return [[NSObject alloc] init];
    }];
}

- (void)testThatReturnedArrayIsNotNil
{
    assertThat(self.result, isNot(nilValue()));
}

- (void)testThatReturnedArrayIsEmpty
{
    assertThat(self.result, hasCountOf(0));
}

@end





@interface CTDArrayAdditionsCreationOfSingleElementListFromBlock
    : CTDArrayAdditionsCreationFromBlockTestCase
@end

@implementation CTDArrayAdditionsCreationOfSingleElementListFromBlock
{
    id _expectedValue;
}
- (void)setUp
{
    [super setUp];
    id element = @13;
    self.result = [NSArray ctd_arrayWithSize:1
                                  usingBlock:^(__unused NSUInteger index)
    {
        return element;
    }];
    _expectedValue = element;
}

- (void)testThatReturnedArrayHasSingleElement
{
    assertThat(self.result, hasCountOf(1));
}

- (void)testThatReturnedArrayContainsElementProducedByBlock
{
    assertThat(self.result, hasItem(_expectedValue));
}

@end





@interface CTDArrayAdditionsCreationOfMultipleItemsFromBlock
    : CTDArrayAdditionsCreationFromBlockTestCase
@end

@implementation CTDArrayAdditionsCreationOfMultipleItemsFromBlock
{
    NSArray* _expectedValues;
}
- (void)setUp
{
    [super setUp];
    NSArray* blockValues = @[
        [NSNumber numberWithInteger:13],
        [NSMutableString stringWithString:@"Test"],
        [[NSObject alloc] init],
        [NSDate dateWithTimeIntervalSince1970:0],
        [NSNumber numberWithDouble:-32700.41]
    ];

    self.result = [NSArray ctd_arrayWithSize:[blockValues count]
                                  usingBlock:^(NSUInteger index)
    {
        return [blockValues objectAtIndex:index];
    }];
    _expectedValues = blockValues;
}

- (void)testThatReturnedArrayHasTheCorrectNumberOfElements
{
    assertThat(self.result, hasCountOf([_expectedValues count]));
}

- (void)testThatReturnedArrayContainsAllElementsProducedByBlockInOrder
{
    assertThat(self.result, containsSameInstancesAs(_expectedValues));
}

@end
