// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDMethodSelector.h"



@interface CTDMethodSelectorTests : XCTestCase

@property (strong, nonatomic) CTDMethodSelector* aDescriptionSelector;
@property (strong, nonatomic) CTDMethodSelector* aCopyWithZoneSelector;
@property (strong, nonatomic) CTDMethodSelector* aGetObjectValueSelector;

@end

@implementation CTDMethodSelectorTests

- (void)setUp
{
    [super setUp];
    self.aDescriptionSelector = [[CTDMethodSelector alloc]
                                 initWithRawSelector:@selector(description)];
    self.aCopyWithZoneSelector = [[CTDMethodSelector alloc]
                                  initWithRawSelector:@selector(copyWithZone:)];
    self.aGetObjectValueSelector = [[CTDMethodSelector alloc]
                                    initWithRawSelector:@selector(
                                        getObjectValue:forString:range:error:)];
}

- (void)tearDown
{
    self.aDescriptionSelector = nil;
    self.aCopyWithZoneSelector = nil;
    self.aGetObjectValueSelector = nil;
    [super tearDown];
}

- (void)testThatDescriptionIsMethodName
{
    assertThat(self.aDescriptionSelector, hasDescription(@"description"));
    assertThat(self.aCopyWithZoneSelector, hasDescription(@"copyWithZone:"));
    assertThat(self.aGetObjectValueSelector,
               hasDescription(@"getObjectValue:forString:range:error:"));
}

- (void)testThatComparisonWithEquivalentRawSelectorReturnsYes
{
    XCTAssertTrue([self.aDescriptionSelector isEqualToRawSelector:@selector(description)], @"");
    XCTAssertTrue([self.aCopyWithZoneSelector isEqualToRawSelector:@selector(copyWithZone:)], @"");
    XCTAssertTrue([self.aGetObjectValueSelector isEqualToRawSelector:
                       @selector(getObjectValue:forString:range:error:)], @"");
}

- (void)testThatComparisonWithDifferentRawSelectorReturnsNo
{
    XCTAssertFalse([self.aDescriptionSelector isEqualToRawSelector:@selector(copy)], @"");
    XCTAssertFalse([self.aDescriptionSelector isEqualToRawSelector:@selector(copyWithZone:)], @"");
    XCTAssertFalse([self.aCopyWithZoneSelector isEqualToRawSelector:@selector(description)], @"");
    XCTAssertFalse([self.aCopyWithZoneSelector isEqualToRawSelector:@selector(copy)], @"");
    XCTAssertFalse([self.aGetObjectValueSelector isEqualToRawSelector:
                        @selector(getObjectValue:forString:errorDescription:)], @"");
    XCTAssertFalse([self.aGetObjectValueSelector isEqualToRawSelector:@selector(description)], @"");
}

- (void)testThatItEqualsAnotherInstanceWithSameRawSelector
{
    assertThat(self.aDescriptionSelector, equalTo(
               [[CTDMethodSelector alloc] initWithRawSelector:@selector(description)]));
    assertThat(self.aGetObjectValueSelector, equalTo(
               [[CTDMethodSelector alloc] initWithRawSelector:
                     @selector(getObjectValue:forString:range:error:)]));
}

- (void)testThatItDoesNotEqualAnotherInstanceWithADifferentRawSelector
{
    assertThat(self.aDescriptionSelector, isNot(equalTo(
               [[CTDMethodSelector alloc] initWithRawSelector:@selector(copyWithZone:)])));
    assertThat(self.aCopyWithZoneSelector, isNot(equalTo(
               [[CTDMethodSelector alloc] initWithRawSelector:@selector(description)])));
}

- (void)testThatItDoesNotEqualTheSelectorNameAsAString
{
    assertThat(self.aDescriptionSelector, isNot(equalTo(@"description")));
    assertThat(self.aCopyWithZoneSelector, isNot(equalTo(@"copyWithZone:")));
    assertThat(self.aGetObjectValueSelector,
               isNot(equalTo(@"getObjectValue:forString:range:error:")));
}

@end
