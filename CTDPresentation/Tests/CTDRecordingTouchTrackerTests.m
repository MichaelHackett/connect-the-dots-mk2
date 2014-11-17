// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingTouchTracker.h"

#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"
#import "CTDUtility/NSArray+CTDBlockBasedFiltering.h"




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
    assertThat(self.subject.lastTouchPosition, is(nilValue()));
}

- (void)testThatMessagesReceivedListIsNotNil
{
    assertThat(self.subject.messagesReceived, isNot(nilValue()));
}

- (void)testThatMessagesReceivedListIsEmpty
{
    assertThat(self.subject.messagesReceived, isEmpty());
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
    assertThat(self.subject.lastTouchPosition, is(equalTo(self.touchPosition)));
}

- (void)testThatMessagesReceivedListContainsSingleElement
{
    assertThat(self.subject.messagesReceived, hasCountOf(1));
}

- (void)testThatMessagesReceivedListContainsExpectedSelector
{
    assertThat(self.subject.messagesReceived,
               hasItem([[CTDMethodSelector alloc]
                        initWithRawSelector:@selector(touchDidMoveTo:)]));
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
    assertThat(self.subject.lastTouchPosition, is(equalTo(self.finalTouchPosition)));
}

- (void)testThatMessagesReceivedContainsAnEntryForEachPositionReceived
{
    assertThat(self.subject.messagesReceived, hasCountOf(5));
}

- (void)testThatMessagesReceivedAreAllTouchMovedMessages
{
    NSArray* nonTouchMovedMessages =
        [self.subject.messagesReceived filteredArrayUsingTest:
            ^BOOL(id obj, __unused NSUInteger index, __unused BOOL* stop)
        {
            return ((CTDMethodSelector*)obj).rawSelector != @selector(touchDidMoveTo:);
        }];
    assertThat(nonTouchMovedMessages, isEmpty());
}

@end




@interface CTDRecordingTouchTrackerAllMessagesTestCase
    : CTDRecordingTouchTrackerBaseTestCase
@end

@implementation CTDRecordingTouchTrackerAllMessagesTestCase

- (void)setUp
{
    [super setUp];
    [self.subject touchDidMoveTo:CTDMakePoint(400,169)];
    [self.subject touchDidEnd];
    [self.subject touchDidEnd];
    [self.subject touchDidMoveTo:CTDMakePoint(880,215)];
    [self.subject touchWasCancelled];
    [self.subject touchDidMoveTo:CTDMakePoint(0,999)];
    [self.subject touchDidEnd];
}

- (void)testDidRecordAllTouchMovedMessages
{
    assertThatUnsignedInt([self countOfMessagesReceivedWithSelector:@selector(touchDidMoveTo:)],
                          is(equalToUnsignedInt(3)));
}

- (void)testDidRecordAllTouchEndedMessages
{
    assertThatUnsignedInt([self countOfMessagesReceivedWithSelector:@selector(touchDidEnd)],
                          is(equalToUnsignedInt(3)));
}

- (void)testDidRecordAllTouchCancelledMessages
{
    assertThatUnsignedInt([self countOfMessagesReceivedWithSelector:@selector(touchWasCancelled)],
                          is(equalToUnsignedInt(1)));
}

@end
