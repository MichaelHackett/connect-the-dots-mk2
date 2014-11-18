// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDMessageRecorder.h"

#import "CTDUtility/CTDMethodSelector.h"

#define message CTDMakeMethodSelector




@interface CTDMessageRecorderBaseTestCase : XCTestCase
@property (strong, nonatomic) CTDMessageRecorder* subject;
@end

@implementation CTDMessageRecorderBaseTestCase

- (void)setUp {
    [super setUp];
    self.subject = [[CTDMessageRecorder alloc] init];
}

@end



@interface CTDMessageRecorderWhenFreshlyCreated : CTDMessageRecorderBaseTestCase
@end

@implementation CTDMessageRecorderWhenFreshlyCreated

- (void)testThatMessagesReceivedListIsNotNil {
    assertThat(self.subject.messagesReceived, isNot(nilValue()));
}

- (void)testThatMessagesReceivedListIsEmpty {
    assertThat(self.subject.messagesReceived, isEmpty());
}

- (void)testThatLastMessageIsNil {
    assertThat([self.subject lastMessage], is(nilValue()));
}

@end



@interface CTDMessageRecorderAfterASingleMessageIsAdded : CTDMessageRecorderBaseTestCase
@end

@implementation CTDMessageRecorderAfterASingleMessageIsAdded

- (void)setUp {
    [super setUp];
    [self.subject addMessageWithSelector:@selector(description)];
}

- (void)testThatMessagesReceivedListContainsSingleElement {
    assertThat(self.subject.messagesReceived, hasCountOf(1));
}

- (void)testThatMessagesReceivedListContainsExpectedSelector {
    assertThat(self.subject.messagesReceived, hasItem(message(description)));
}

- (void)testThatHasReceivedMessageMethodReturnsTrueForTheMessageSent {
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(description)],
                   is(equalToBool(YES)));
}

- (void)testThatHasReceivedMessageMethodReturnsFalseForADifferentMessage {
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(copy)],
                   is(equalToBool(NO)));
}

- (void)testThatLastMessageReceivedMatchesSelectorOfSingleMessage {
    assertThat([self.subject lastMessage], is(equalTo(message(description))));
}

@end


@interface CTDMessageRecorderAfterSeveralMessages : CTDMessageRecorderBaseTestCase
@end

@implementation CTDMessageRecorderAfterSeveralMessages

- (void)setUp {
    [super setUp];
    [self.subject addMessageWithSelector:@selector(performSelector:)];
    [self.subject addMessageWithSelector:@selector(hash)];
    [self.subject addMessageWithSelector:@selector(isKindOfClass:)];
    [self.subject addMessageWithSelector:@selector(hash)];
}

- (void)testThatMessagesReceivedIncludesAnEntryForEachMessageReceived {
    assertThat(self.subject.messagesReceived, hasCountOf(4));
}

- (void)testThatMessagesReceivedListContainsAllSentSelectors {
    assertThat(self.subject.messagesReceived, hasItem(message(performSelector:)));
    assertThat(self.subject.messagesReceived, hasItem(message(hash)));
    assertThat(self.subject.messagesReceived, hasItem(message(isKindOfClass:)));
}

- (void)testThatHasReceivedMessageMethodReturnsTrueForAllMessagesSent {
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(hash)],
                   is(equalToBool(YES)));
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(isKindOfClass:)],
                   is(equalToBool(YES)));
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(performSelector:)],
                   is(equalToBool(YES)));
}

- (void)testThatHasReceivedMessageMethodReturnsFalseForADifferentMessage {
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(description)],
                   is(equalToBool(NO)));
}

- (void)testThatLastMessageReceivedMatchesSelectorOfFinalMessageSent {
    assertThat([self.subject lastMessage], is(equalTo(message(hash))));
}

@end




@interface CTDMessageRecorderAfterReset : CTDMessageRecorderBaseTestCase
@end
@implementation CTDMessageRecorderAfterReset

- (void)setUp {
    [super setUp];
    [self.subject addMessageWithSelector:@selector(copy)];
    [self.subject addMessageWithSelector:@selector(performSelector:withObject:)];
    [self.subject reset];
}

- (void)testThatMessagesReceivedListIsEmpty {
    assertThat(self.subject.messagesReceived, isEmpty());
}

- (void)testThatLastMessageReturnsNil {
    assertThat([self.subject lastMessage], is(nilValue()));
}

- (void)testThatHasReceivedMessageMethodReturnsFalseForAllMessagesSent {
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(copy)],
                   is(equalToBool(NO)));
    assertThatBool([self.subject hasReceivedMessageWithSelector:
                                     @selector(performSelector:withObject:)],
                   is(equalToBool(NO)));
}

@end




@interface CTDMessageRecorderWhenNewMessagesAreSentAfterAReset
    : CTDMessageRecorderBaseTestCase
@end
@implementation CTDMessageRecorderWhenNewMessagesAreSentAfterAReset

- (void)setUp {
    [super setUp];
    [self.subject addMessageWithSelector:@selector(copy)];
    [self.subject addMessageWithSelector:@selector(performSelector:withObject:)];
    [self.subject reset];
    [self.subject addMessageWithSelector:@selector(description)];
    [self.subject addMessageWithSelector:@selector(performSelector:)];
}

- (void)testThatMessagesReceivedIncludesAnEntryForEachMessageReceivedAfterTheReset {
    assertThat(self.subject.messagesReceived, hasCountOf(2));
}

- (void)testThatMessagesReceivedListContainsAllSentSelectorsSentAfterTheReset {
    assertThat(self.subject.messagesReceived, hasItem(message(performSelector:)));
    assertThat(self.subject.messagesReceived, hasItem(message(description)));
}

- (void)testThatHasReceivedMessageMethodReturnsTrueForAllMessagesSentAfterTheReset {
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(description)],
                   is(equalToBool(YES)));
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(performSelector:)],
                   is(equalToBool(YES)));
}

- (void)testThatHasReceivedMessageMethodReturnsFalseForAllMessagesSentBeforeTheReset {
    assertThatBool([self.subject hasReceivedMessageWithSelector:@selector(copy)],
                   is(equalToBool(NO)));
    assertThatBool([self.subject hasReceivedMessageWithSelector:
                                     @selector(performSelector:withObject:)],
                   is(equalToBool(NO)));
}

@end
