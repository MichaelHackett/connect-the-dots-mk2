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

- (void)testThatRecordedMessageWasReceivedOneTime
{
    assertThatUnsignedInt([self.subject countOfMessagesReceivedThatMatch:@selector(open)],
                          equalToUnsignedInt(1));
}

- (void)testThatOtherMessagesWereReceivedZeroTimes
{ // obviously, we cannot test against *all* other messages; just work with others in the protocol
    assertThatUnsignedInt([self.subject countOfMessagesReceivedThatMatch:@selector(close)],
                          equalToUnsignedInt(0));
    assertThatUnsignedInt([self.subject countOfMessagesReceivedThatMatch:@selector(readDataInto:)],
                          equalToUnsignedInt(0));
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

- (void)testThatRecordedMessageWasReceivedOneTime
{
    assertThatUnsignedInt([self.subject countOfMessagesReceivedThatMatch:@selector(close)],
                          equalToUnsignedInt(2));
}

- (void)testThatOtherMessagesWereReceivedZeroTimes
{
    assertThatUnsignedInt([self.subject countOfMessagesReceivedThatMatch:@selector(open)],
                          equalToUnsignedInt(0));
    assertThatUnsignedInt([self.subject countOfMessagesReceivedThatMatch:@selector(readDataInto:)],
                          equalToUnsignedInt(0));
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

- (void)testThatEachRecordedMessageWasReceivedOneTime
{
    assertThatUnsignedInt([self.subject countOfMessagesReceivedThatMatch:@selector(open)],
                          equalToUnsignedInt(1));
    assertThatUnsignedInt([self.subject countOfMessagesReceivedThatMatch:@selector(close)],
                          equalToUnsignedInt(1));
}

- (void)testThatOtherMessagesWereReceivedZeroTimes
{
    assertThatUnsignedInt([self.subject countOfMessagesReceivedThatMatch:@selector(readDataInto:)],
                          equalToUnsignedInt(0));
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
    assertThatUnsignedInt([self.subject countOfMessagesReceivedThatMatch:@selector(open)],
                          equalToUnsignedInt(0));
    assertThatUnsignedInt([self.subject countOfMessagesReceivedThatMatch:@selector(close)],
                          equalToUnsignedInt(0));
}

@end
