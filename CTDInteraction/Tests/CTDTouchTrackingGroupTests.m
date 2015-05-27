// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDTouchTrackingGroup.h"

#import "CTDRecordingTouchTracker.h"
#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"



@interface CTDTouchTrackingGroupBaseTestCase : XCTestCase
@property (strong, nonatomic) CTDTouchTrackingGroup* subject;
@end

@implementation CTDTouchTrackingGroupBaseTestCase

- (void)setUp
{
    [super setUp];
    self.subject = [[CTDTouchTrackingGroup alloc] init];
}

@end




@interface CTDEmptyTouchTrackingGroupTestCase : CTDTouchTrackingGroupBaseTestCase
@end

@implementation CTDEmptyTouchTrackingGroupTestCase

- (void)testThatItHandlesAllTrackingMessagesWithoutError
{
    XCTAssertNoThrow([self.subject touchDidMoveTo:[CTDPoint origin]],
                     @"expected no exception");
    XCTAssertNoThrow([self.subject touchDidEnd], @"expected no exception");
    XCTAssertNoThrow([self.subject touchWasCancelled], @"expected no exception");
}

@end




@interface CTDMultipleElementTouchTrackingGroupTestCase
    : CTDTouchTrackingGroupBaseTestCase
@property (strong, nonatomic) NSArray* trackers;
@end

@implementation CTDMultipleElementTouchTrackingGroupTestCase

- (void)setUp
{
    [super setUp];
    self.trackers = @[
        [[CTDRecordingTouchTracker alloc] init],
        [[CTDRecordingTouchTracker alloc] init],
        [[CTDRecordingTouchTracker alloc] init]
    ];
    for (id tracker in self.trackers) {
        [self.subject addTracker:tracker];
    }
}

- (NSArray*)trackerMostRecentMessages
{
    NSMutableArray* lastMessageList =
        [NSMutableArray arrayWithCapacity:[self.trackers count]];
    for (CTDRecordingTouchTracker* tracker in self.trackers) {
        id lastMessage = [[tracker touchTrackingMesssagesReceived] lastObject];
        if (!lastMessage) {
            lastMessage = [NSNull null];
        }
        [lastMessageList addObject:lastMessage];
    }
    return [lastMessageList copy];
}

- (NSArray*)arrayWithCount:(NSUInteger)count copiesOfSelector:(SEL)selector
{
    CTDMethodSelector* original = [[CTDMethodSelector alloc]
                                   initWithRawSelector:selector];
    NSMutableArray* messages = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger index = 0; index < count; index += 1) {
        [messages addObject:[original copy]];
    }
    return [messages copy];
}

- (void)testForwardsTouchMovedMessagesToGroupMembers
{
    CTDPoint* touchPosition = [[CTDPoint alloc] initWithX:300 y:175];
    [self.subject touchDidMoveTo:touchPosition];
    assertThat([self trackerMostRecentMessages],
               is(equalTo([self arrayWithCount:[self.trackers count]
                                copiesOfSelector:@selector(touchDidMoveTo:)])));
}

- (void)testForwardsTouchEndedMessagesToGroupMembers
{
    [self.subject touchDidEnd];
    assertThat([self trackerMostRecentMessages],
               is(equalTo([self arrayWithCount:[self.trackers count]
                                copiesOfSelector:@selector(touchDidEnd)])));
}

- (void)testForwardsTouchCancelledMessagesToGroupMembers
{
    [self.subject touchWasCancelled];
    assertThat([self trackerMostRecentMessages],
               is(equalTo([self arrayWithCount:[self.trackers count]
                                copiesOfSelector:@selector(touchWasCancelled)])));
}

@end
