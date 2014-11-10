// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDMethodSelector.h"

#import <XCTest/XCTest.h>



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
    XCTAssertEqualObjects([self.aDescriptionSelector description],
                          @"description",
                          @"expected object description to equal selector name");
    XCTAssertEqualObjects([self.aCopyWithZoneSelector description],
                          @"copyWithZone:",
                          @"expected object description to equal selector name");
    XCTAssertEqualObjects([self.aGetObjectValueSelector description],
                          @"getObjectValue:forString:range:error:",
                          @"expected object description to equal selector name");
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
    XCTAssertTrue([self.aDescriptionSelector isEqual:
                   [[CTDMethodSelector alloc] initWithRawSelector:@selector(description)]], @"");
    XCTAssertTrue([self.aGetObjectValueSelector isEqual:
                   [[CTDMethodSelector alloc] initWithRawSelector:
                       @selector(getObjectValue:forString:range:error:)]],
                  @"");
}

- (void)testThatItDoesNotEqualAnotherInstanceWithADifferentRawSelector
{
    XCTAssertFalse([self.aDescriptionSelector isEqual:
                    [[CTDMethodSelector alloc] initWithRawSelector:@selector(copyWithZone:)]], @"");
    XCTAssertFalse([self.aCopyWithZoneSelector isEqual:
                    [[CTDMethodSelector alloc] initWithRawSelector:@selector(description)]], @"");
}

- (void)testThatItDoesNotEqualTheSelectorNameAsAString
{
    XCTAssertFalse([self.aDescriptionSelector isEqual:@"description"], @"");
    XCTAssertFalse([self.aCopyWithZoneSelector isEqual:@"copyWithZone:"], @"");
    XCTAssertFalse([self.aGetObjectValueSelector
                    isEqual:@"getObjectValue:forString:range:error:"], @"");
}

@end
