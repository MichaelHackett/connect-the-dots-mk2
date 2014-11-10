// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingTouchTracker.h"

#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"
#import "CTDUtility/NSArray+CTDBlockBasedFiltering.h"
#import <XCTest/XCTest.h>




@interface CTDRecordingTouchTrackerBaseTestCase : XCTestCase
@property (strong, nonatomic) CTDRecordingTouchTracker* subject;
@end

@implementation CTDRecordingTouchTrackerBaseTestCase

- (void)setUp
{
    [super setUp];
    self.subject = [[CTDRecordingTouchTracker alloc] init];
}

- (void)tearDown
{
    self.subject = nil;
    [super tearDown];
}

- (NSUInteger)countOfMessagesReceivedWithSelector:(SEL)selector
{
    return [[self.subject.messagesReceived indexesOfObjectsPassingTest:
        ^BOOL(id obj, __unused NSUInteger index, __unused BOOL* stop)
    {
        return ((CTDMethodSelector*)obj).rawSelector == selector;
    }] count];
}

@end



@interface CTDFreshRecordingTouchTrackerTestCase : CTDRecordingTouchTrackerBaseTestCase
@end

@implementation CTDFreshRecordingTouchTrackerTestCase

- (void)testThatInitialTouchPositionIsNil
{
    XCTAssertNil(self.subject.lastTouchPosition, @"");
}

- (void)testThatMessagesReceivedListIsNotNil
{
    XCTAssertNotNil(self.subject.messagesReceived, @"");
}

- (void)testThatMessagesReceivedListIsEmpty
{
    XCTAssertEqual([self.subject.messagesReceived count], 0u,
                   @"count of elements should be 0");
}

@end



@interface CTDRecordingTouchTrackerAfterASinglePositionChangeMessageTestCase
    : CTDRecordingTouchTrackerBaseTestCase
@property (copy, nonatomic) CTDPoint* touchPosition;
@end

@implementation CTDRecordingTouchTrackerAfterASinglePositionChangeMessageTestCase

- (void)setUp
{
    [super setUp];
    self.touchPosition = [[CTDPoint alloc] initWithX:181 y:820];
    [self.subject touchDidMoveTo:self.touchPosition];
}

- (void)tearDown
{
    self.touchPosition = nil;
    [super tearDown];
}

- (void)testThatTouchPositionEqualsOneInPositionChangeMessage
{
    XCTAssertEqualObjects(self.subject.lastTouchPosition, self.touchPosition, @"");
}

- (void)testThatMessagesReceivedListContainsSingleElement
{
    XCTAssertEqual([self.subject.messagesReceived count], 1u, @"");
}

- (void)testThatMessagesReceivedListContainsExpectedSelector
{
    XCTAssertTrue([self.subject.messagesReceived
                   containsObject:[[CTDMethodSelector alloc]
                                   initWithRawSelector:@selector(touchDidMoveTo:)]],
                  @"");
}

@end


@interface CTDRecordingTouchTrackerAfterSeveralPositionChangeMessagesTestCase
    : CTDRecordingTouchTrackerBaseTestCase
@property (copy, nonatomic) CTDPoint* finalTouchPosition;
@end

@implementation CTDRecordingTouchTrackerAfterSeveralPositionChangeMessagesTestCase

- (void)setUp
{
    [super setUp];
    NSArray* touchPositions = @[
        [[CTDPoint alloc] initWithX:120 y:556],
        [[CTDPoint alloc] initWithX:240 y:379],
        [[CTDPoint alloc] initWithX:355 y:131]
    ];
    [self.subject touchDidMoveTo:touchPositions[0]];
    [self.subject touchDidMoveTo:touchPositions[1]];
    [self.subject touchDidMoveTo:touchPositions[0]];
    [self.subject touchDidMoveTo:touchPositions[2]];
    [self.subject touchDidMoveTo:touchPositions[1]];
    self.finalTouchPosition = touchPositions[1];
}

- (void)tearDown
{
    self.finalTouchPosition = nil;
    [super tearDown];
}

- (void)testThatTouchPositionIsLastPositionReceived
{
    XCTAssertEqualObjects(self.subject.lastTouchPosition, self.finalTouchPosition, @"");
}

- (void)testThatMessagesReceivedContainsAnEntryForEachPositionReceived
{
    XCTAssertEqual([self.subject.messagesReceived count], 5u, @"");
}

- (void)testThatMessagesReceivedAreAllTouchMovedMessages
{
    NSArray* nonTouchMovedMessages =
        [self.subject.messagesReceived filteredArrayUsingTest:
            ^BOOL(id obj, __unused NSUInteger index, __unused BOOL* stop)
        {
            return ((CTDMethodSelector*)obj).rawSelector != @selector(touchDidMoveTo:);
        }];
    XCTAssertEqualObjects(nonTouchMovedMessages, @[], @"expected empty array");
}

@end




@interface CTDRecordingTouchTrackerAllMessagesTestCase
    : CTDRecordingTouchTrackerBaseTestCase
@end

@implementation CTDRecordingTouchTrackerAllMessagesTestCase

- (void)setUp
{
    [super setUp];
    [self.subject touchDidMoveTo:[[CTDPoint alloc] initWithX:400 y:169]];
    [self.subject touchDidEnd];
    [self.subject touchDidEnd];
    [self.subject touchDidMoveTo:[[CTDPoint alloc] initWithX:880 y:215]];
    [self.subject touchWasCancelled];
    [self.subject touchDidMoveTo:[[CTDPoint alloc] initWithX:0 y:999]];
    [self.subject touchDidEnd];
}

- (void)testDidRecordAllTouchMovedMessages
{
    XCTAssertEqual([self countOfMessagesReceivedWithSelector:@selector(touchDidMoveTo:)],
                   3u,
                   @"sent 3 touchDidMoveTo: messages");
}

- (void)testDidRecordAllTouchEndedMessages
{
    XCTAssertEqual([self countOfMessagesReceivedWithSelector:@selector(touchDidEnd)],
                   3u,
                   @"sent 3 touchDidEnd messages");
}

- (void)testDidRecordAllTouchCancelledMessages
{
    XCTAssertEqual([self countOfMessagesReceivedWithSelector:@selector(touchWasCancelled)],
                   1u,
                   @"sent 1 touchWasCancelled messages");
}

@end
