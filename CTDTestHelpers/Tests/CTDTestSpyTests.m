// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTestSpy.h"


@protocol CTDTestSpyTestProtocol

- (void)open;
- (void)close;
- (int)readDataInto:(NSData*)buffer;

@end



@interface CTDTestSpyBaseTestCase : XCTestCase
@property (strong, nonatomic) CTDTestSpy* subject;
@end

@implementation CTDTestSpyBaseTestCase

- (void)setUp {
    [super setUp];
    self.subject = [[CTDTestSpy alloc] init];
}

@end



@interface CTDTestSpyWhenFreshlyCreated : CTDTestSpyBaseTestCase
@end

@implementation CTDTestSpyWhenFreshlyCreated

//- (void)testThatLastMessageIsNil {
//    assertThat([self.subject lastMessage], is(nilValue()));
//}

@end



@interface CTDTestSpyAfterSingleMessage : CTDTestSpyBaseTestCase
@end
@implementation CTDTestSpyAfterSingleMessage

- (void)setUp {
    [super setUp];
    [self.subject recordMessageWithSelector:@selector(open)];
}

- (void)testThatRecordedMessageIsReportedAsBeingReceivedOneTime
{
    assertThatUnsignedInt([self.subject countOfMessagesReceivedWithSelector:@selector(open)],
                          is(equalToUnsignedInt(1)));
}

- (void)testThatOtherMessagesAreReportedAsBeingReceivedZeroTimes
{ // obviously, we cannot test against *all* other messages; just work with others in the protocol
    assertThatUnsignedInt([self.subject countOfMessagesReceivedWithSelector:@selector(close)],
                          is(equalToUnsignedInt(0)));
    assertThatUnsignedInt([self.subject countOfMessagesReceivedWithSelector:@selector(readDataInto:)],
                          is(equalToUnsignedInt(0)));
}

- (void)testThatRecordedMessageIsReportedAsHavingBeenReceived
{
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(open)],
                   is(equalToBool(YES)));
}

- (void)testThatOtherMessagesAreReportedAsNotBeingReceived
{
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(close)],
                   is(equalToBool(NO)));
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(readDataInto:)],
                   is(equalToBool(NO)));
}

@end




@interface CTDTestSpyAfterTwoIdenticalMessages : CTDTestSpyBaseTestCase
@end
@implementation CTDTestSpyAfterTwoIdenticalMessages

- (void)setUp {
    [super setUp];
    [self.subject recordMessageWithSelector:@selector(close)];
    [self.subject recordMessageWithSelector:@selector(close)];
}

- (void)testThatRecordedMessageIsReportedAsBeingReceivedTwoTimes
{
    assertThatUnsignedInt([self.subject countOfMessagesReceivedWithSelector:@selector(close)],
                          is(equalToUnsignedInt(2)));
}

- (void)testThatOtherMessagesAreReportedAsBeingReceivedZeroTimes
{
    assertThatUnsignedInt([self.subject countOfMessagesReceivedWithSelector:@selector(open)],
                          is(equalToUnsignedInt(0)));
    assertThatUnsignedInt([self.subject countOfMessagesReceivedWithSelector:@selector(readDataInto:)],
                          is(equalToUnsignedInt(0)));
}

- (void)testThatRecordedMessageIsReportedAsHavingBeenReceived
{
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(close)],
                   is(equalToBool(YES)));
}

- (void)testThatOtherMessagesAreReportedAsNotBeingReceived
{
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(open)],
                   is(equalToBool(NO)));
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(readDataInto:)],
                   is(equalToBool(NO)));
}

@end




@interface CTDTestSpyAfterTwoDifferentMessages : CTDTestSpyBaseTestCase
@end
@implementation CTDTestSpyAfterTwoDifferentMessages

- (void)setUp {
    [super setUp];
    [self.subject recordMessageWithSelector:@selector(open)];
    [self.subject recordMessageWithSelector:@selector(close)];
}

- (void)testThatEachRecordedMessageIsReportedAsBeingReceivedOneTime
{
    assertThatUnsignedInt([self.subject countOfMessagesReceivedWithSelector:@selector(open)],
                          is(equalToUnsignedInt(1)));
    assertThatUnsignedInt([self.subject countOfMessagesReceivedWithSelector:@selector(close)],
                          is(equalToUnsignedInt(1)));
}

- (void)testThatOtherMessagesAreReportedAsBeingReceivedZeroTimes
{
    assertThatUnsignedInt([self.subject countOfMessagesReceivedWithSelector:@selector(readDataInto:)],
                          is(equalToUnsignedInt(0)));
}

- (void)testThatRecordedMessageIsReportedAsHavingBeenReceived
{
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(open)],
                   is(equalToBool(YES)));
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(close)],
                   is(equalToBool(YES)));
}

- (void)testThatOtherMessagesAreReportedAsNotBeingReceived
{
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(readDataInto:)],
                   is(equalToBool(NO)));
}

@end

@interface CTDTestSpyAfterReset : CTDTestSpyBaseTestCase
@end
@implementation CTDTestSpyAfterReset

- (void)setUp {
    [super setUp];
    [self.subject recordMessageWithSelector:@selector(open)];
    [self.subject recordMessageWithSelector:@selector(close)];
    [self.subject reset];
}

- (void)testThatMessagesSentPriorToResetAreNoLongerCounted
{
    assertThatUnsignedInt([self.subject countOfMessagesReceivedWithSelector:@selector(open)],
                          is(equalToUnsignedInt(0)));
    assertThatUnsignedInt([self.subject countOfMessagesReceivedWithSelector:@selector(close)],
                          is(equalToUnsignedInt(0)));
}

- (void)testThatMessagesSentPriorToResetAreReportedAsNotBeingReceived
{
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(close)],
                   is(equalToBool(NO)));
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(open)],
                   is(equalToBool(NO)));
}

@end
