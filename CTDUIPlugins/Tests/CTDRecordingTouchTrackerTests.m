// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingTouchTracker.h"

#import "CTDUtility/CTDMethodSelector.h"
#import "CTDUtility/CTDPoint.h"

#define message CTDMakeMethodSelector




@interface CTDRecordingTouchTrackerBaseTestCase : XCTestCase
@property (strong, nonatomic) CTDRecordingTouchTracker* subject;
@end

@implementation CTDRecordingTouchTrackerBaseTestCase

- (void)setUp
{
    [super setUp];
    self.subject = [[CTDRecordingTouchTracker alloc] init];
}

@end




@interface CTDRecordingTouchTrackerInitialState
    : CTDRecordingTouchTrackerBaseTestCase
@end

@implementation CTDRecordingTouchTrackerInitialState

- (void)testThatTouchPositionIsNil
{
    assertThat(self.subject.lastTouchPosition, is(nilValue()));
}

- (void)testThatLastTrackerMessageIsNil
{
    assertThat(self.subject.lastTrackerMessage, is(nilValue()));
}

- (void)testThatItReportsThatZeroTrackerMessagesHaveBeenReceived
{
    assertThatUnsignedInt([self.subject countOfTrackerMessagesReceived],
                          is(equalToUnsignedInt(0)));
}

@end




@interface CTDRecordingTouchTrackerAfterASinglePositionChangeMessage
    : CTDRecordingTouchTrackerBaseTestCase
@property (copy, nonatomic) CTDPoint* touchPosition;
@end

@implementation CTDRecordingTouchTrackerAfterASinglePositionChangeMessage

- (void)setUp
{
    [super setUp];
    self.touchPosition = [[CTDPoint alloc] initWithX:181 y:820];
    [self.subject touchDidMoveTo:self.touchPosition];
}

- (void)testThatTouchPositionEqualsTheOneInPositionChangeMessage
{
    assertThat(self.subject.lastTouchPosition, is(equalTo(self.touchPosition)));
}

- (void)testThatLastTrackerMessageWasPositionChangeMessage
{
    assertThat(self.subject.lastTrackerMessage, is(equalTo(message(touchDidMoveTo:))));
}

- (void)testThatItHasRecordedReceivingASingleProtocolMessage
{
    assertThatUnsignedInteger([self.subject countOfTrackerMessagesReceived],
                              is(equalToUnsignedInteger(1)));
}

- (void)testThatItHasRecordedReceivingTheSentMessage
{
    assertThatUnsignedInt([self.subject countOfMessagesReceivedWithSelector:@selector(touchDidMoveTo:)],
                          is(greaterThanOrEqualTo(@1)));
}

- (void)testThatItDoesNotReportReceivingUnsentProtocolMessages
{
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(touchDidEnd)],
                   is(equalToBool(NO)));
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(touchWasCancelled)],
                   is(equalToBool(NO)));
}

@end




@interface CTDRecordingTouchTrackerAfterSeveralPositionChangeMessages
    : CTDRecordingTouchTrackerBaseTestCase
@property (copy, nonatomic) CTDPoint* finalTouchPosition;
@end

@implementation CTDRecordingTouchTrackerAfterSeveralPositionChangeMessages

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

- (void)testThatTouchPositionIsLastPositionReceived
{
    assertThat(self.subject.lastTouchPosition, is(equalTo(self.finalTouchPosition)));
}

- (void)testThatLastTrackerMessageWasPositionChangeMessage
{
    assertThat(self.subject.lastTrackerMessage, is(equalTo(message(touchDidMoveTo:))));
}

- (void)testThatItHasRecordedReceivingAllProtocolMessages
{
    assertThatUnsignedInteger([self.subject countOfTrackerMessagesReceived],
                              is(equalToUnsignedInteger(5)));
}

- (void)testThatItHasRecordedReceivingTheSentMessage
{
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(touchDidMoveTo:)],
                   is(equalToBool(YES)));
}

- (void)testThatItDoesNotReportReceivingUnsentProtocolMessages
{
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(touchDidEnd)],
                   is(equalToBool(NO)));
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(touchWasCancelled)],
                   is(equalToBool(NO)));
}

@end




@interface CTDRecordingTouchTrackerHavingReceivedAllProtocolMessages
    : CTDRecordingTouchTrackerBaseTestCase
@end

@implementation CTDRecordingTouchTrackerHavingReceivedAllProtocolMessages

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

- (void)testThatItHasRecordedReceivingAllProtocolMessages
{
    assertThatUnsignedInteger([self.subject countOfTrackerMessagesReceived],
                              is(equalToUnsignedInteger(7)));
}

- (void)testThatLastTrackerMessageWasTouchEndMessage
{
    assertThat(self.subject.lastTrackerMessage, is(equalTo(message(touchDidEnd))));
}

- (void)testThatItHasRecordedReceivingAllSentMessages
{
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(touchDidMoveTo:)],
                   is(equalToBool(YES)));
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(touchDidEnd)],
                   is(equalToBool(YES)));
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(touchWasCancelled)],
                   is(equalToBool(YES)));
}

@end




// expect state after reset to be identical to initial, so use all the same
// assertions as that test case (just override setup)

@interface CTDRecordingTouchTrackerAfterReset
    : CTDRecordingTouchTrackerInitialState
@end

@implementation CTDRecordingTouchTrackerAfterReset

- (void)setUp
{
    [super setUp];
    [self.subject touchDidMoveTo:CTDMakePoint(0,999)];
    [self.subject touchDidEnd];
    [self.subject touchWasCancelled];
    [self.subject reset];
}

@end
