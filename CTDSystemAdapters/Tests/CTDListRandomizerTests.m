// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDDefaultRandomalizer.h"



@interface CTDListRandomizerTestCase : XCTestCase

@property (strong, nonatomic) CTDDefaultRandomalizer* subject;
@property (strong, nonatomic) NSArray* inputList;
@property (strong, nonatomic) NSArray* outputList;
@property (assign, nonatomic) NSUInteger originalSeed;

@end

@implementation CTDListRandomizerTestCase

- (void)setUp
{
    [super setUp];
    self.subject = [[CTDDefaultRandomalizer alloc] init];
}

- (void)exerciseWithInputList:(NSArray*)inputList seed:(unsigned long)seed
{
    self.inputList = [inputList copy];
    self.originalSeed = seed;
    self.outputList = [self.subject randomizeList:inputList seed:seed];
}

@end




@interface CTDListRandomizerGivenEmptyList : CTDListRandomizerTestCase
@end

@implementation CTDListRandomizerGivenEmptyList

- (void)setUp
{
    [super setUp];
    [self exerciseWithInputList:@[] seed:1];
}

- (void)testThatSequenceHasZeroLength
{
    assertThat(self.outputList, hasCountOf(0));
}

@end




@interface CTDListRandomizerGivenSingleItemList : CTDListRandomizerTestCase
@end

@implementation CTDListRandomizerGivenSingleItemList

- (void)setUp
{
    [super setUp];
    [self exerciseWithInputList:@[@25] seed:99];
}

- (void)testThatSequenceHasOneElement
{
    assertThat(self.outputList, hasCountOf(1));
}

- (void)testThatOutputListContainsSameElementAsInputList
{
    assertThat(self.outputList[0], is(equalTo(self.inputList[0])));
}

@end





@interface CTDListRandomizerGivenMultipleItemList : CTDListRandomizerTestCase
@end

@implementation CTDListRandomizerGivenMultipleItemList

- (void)setUp
{
    [super setUp];
    [self exerciseWithInputList:@[@1, @2, @"3", @99.5, @"abc", @-7762, @19232, @"bar", @4]
                           seed:7777];
}

- (void)testThatSequenceHasExpectedLength
{
    assertThat(self.outputList, hasCountOf([self.inputList count]));
}

- (void)testThatOutputListHasSameElementsAsInputList
{
    assertThat(self.outputList, containsInAnyOrderSameInstancesAs(self.inputList));
}

- (void)testThatOutputListHasDifferentOrderThanInputList
{
    assertThat(self.outputList, isNot(equalTo(self.inputList)));
}

- (void)testThatListHasSameOrderIfGeneratedAgainWithSameSeed
{
    NSArray* firstOutputList = [self.outputList copy];
    [self exerciseWithInputList:self.inputList seed:self.originalSeed];
    assertThat(self.outputList, is(equalTo(firstOutputList)));
}

- (void)testThatDifferentValuesReturnedIfCalledWithDifferentSeed
{
    NSArray* firstOutputList = [self.outputList copy];
    [self exerciseWithInputList:self.inputList seed:self.originalSeed + 1];
    assertThat(self.outputList, isNot(equalTo(firstOutputList)));
}

- (void)testThatAllElementsAreAffected
{
    NSArray* firstOutputList = [self.outputList copy];
    [self exerciseWithInputList:self.inputList seed:self.originalSeed + 1];
    NSArray* secondOutputList = [self.outputList copy];
    [self exerciseWithInputList:self.inputList seed:self.originalSeed + 2];

    NSUInteger length = [self.outputList count];
    for (NSUInteger i = 0; i < length; i += 1)
    {
        assertThat(firstOutputList[i], isNot(allOf(equalTo(secondOutputList[i]),
                                                   equalTo(self.outputList[i]),
                                                   nil)));
    }
}

// This is a performance test, not really a unit test, since it's possible to
// fail this test and still be a good implementation, just by hitting upon a
// bad combination of seeds. However, if it does fail, it warrants
// investigation as to why, and more extensive testing with many seeds. Once
// the test passes, though, it should continue to pass, unless something about
// the implementation changes, as the use of seeds should make the generators
// completely predictable.
- (void)testThatMostElementsAreMovedFromOriginalPositions
{
    NSArray* firstOutputList = [self.outputList copy];
    [self exerciseWithInputList:self.inputList seed:self.originalSeed + 1];
    NSArray* secondOutputList = self.outputList;

    // Allow up to 2 elements to remain in the same spots.
    NSUInteger minimumMoves = [self.inputList count] - 2;

    assertThatUnsignedInteger([[self class] numberOfMismatchesBetweenFirst:self.inputList
                                                                 andSecond:firstOutputList],
                              is(greaterThanOrEqualTo(@(minimumMoves))));
    assertThatUnsignedInteger([[self class] numberOfMismatchesBetweenFirst:self.inputList
                                                                 andSecond:secondOutputList],
                              is(greaterThanOrEqualTo(@(minimumMoves))));
    assertThatUnsignedInteger([[self class] numberOfMismatchesBetweenFirst:firstOutputList
                                                                 andSecond:secondOutputList],
                              is(greaterThanOrEqualTo(@(minimumMoves))));
}

+ (NSUInteger)numberOfMismatchesBetweenFirst:(NSArray*)first andSecond:(NSArray*)second
{
    NSUInteger mismatchCount = 0;
    NSUInteger length = MIN([first count], [second count]);
    for (NSUInteger i = 0; i < length; i += 1)
    {
        if (![first[i] isEqual:second[i]]) { mismatchCount += 1; }
    }
    NSLog(@"*** number of changes = %lu", (unsigned long)mismatchCount);
    return mismatchCount;
}

@end
