// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDMessageList.h"

#import "CTDUtility/CTDMethodSelector.h"

#define message CTDMakeMethodSelector




@interface CTDMessageListBaseTestCase : XCTestCase
@property (strong, nonatomic) CTDMessageList* subject;
@end

@implementation CTDMessageListBaseTestCase

- (void)setUp {
    [super setUp];
    self.subject = [[CTDMessageList alloc] init];
}

@end



@interface CTDMessageListWhenFreshlyCreated : CTDMessageListBaseTestCase
@end

@implementation CTDMessageListWhenFreshlyCreated

- (void)testThatListIsNotNil {
    assertThat(self.subject.messageSelectors, isNot(nilValue()));
}

- (void)testThatListIsEmpty {
    assertThat(self.subject.messageSelectors, isEmpty());
}

- (void)testThatLastMessageIsNil {
    assertThat([self.subject lastMessage], is(nilValue()));
}

@end



@interface CTDMessageListAfterASingleMessageIsAdded : CTDMessageListBaseTestCase
@end

@implementation CTDMessageListAfterASingleMessageIsAdded

- (void)setUp {
    [super setUp];
    [self.subject addMessageWithSelector:@selector(description)];
}

- (void)testThatListContainsSingleElement {
    assertThat(self.subject.messageSelectors, hasCountOf(1));
}

- (void)testThatListContainsExpectedSelector {
    assertThat(self.subject.messageSelectors, hasItem(message(description)));
}

- (void)testThatIncludesMessageMethodReturnsTrueForTheMessageSent {
    assertThatBool([self.subject includesMessageWithSelector:@selector(description)],
                   is(equalToBool(YES)));
}

- (void)testThatIncludesMessageMethodReturnsFalseForADifferentMessage {
    assertThatBool([self.subject includesMessageWithSelector:@selector(copy)],
                   is(equalToBool(NO)));
}

- (void)testThatLastMessageReceivedMatchesSelectorOfSingleMessage {
    assertThat([self.subject lastMessage], is(equalTo(message(description))));
}

@end


@interface CTDMessageListAfterSeveralMessages : CTDMessageListBaseTestCase
@end

@implementation CTDMessageListAfterSeveralMessages

- (void)setUp {
    [super setUp];
    [self.subject addMessageWithSelector:@selector(performSelector:)];
    [self.subject addMessageWithSelector:@selector(hash)];
    [self.subject addMessageWithSelector:@selector(isKindOfClass:)];
    [self.subject addMessageWithSelector:@selector(hash)];
}

- (void)testThatListIncludesAnEntryForEachMessageReceived {
    assertThat(self.subject.messageSelectors, hasCountOf(4));
}

- (void)testThatListIncludesAllSentSelectors {
    assertThat(self.subject.messageSelectors, hasItem(message(performSelector:)));
    assertThat(self.subject.messageSelectors, hasItem(message(hash)));
    assertThat(self.subject.messageSelectors, hasItem(message(isKindOfClass:)));
}

- (void)testThatIncludesMessageMethodReturnsTrueForAllMessagesSent {
    assertThatBool([self.subject includesMessageWithSelector:@selector(hash)],
                   is(equalToBool(YES)));
    assertThatBool([self.subject includesMessageWithSelector:@selector(isKindOfClass:)],
                   is(equalToBool(YES)));
    assertThatBool([self.subject includesMessageWithSelector:@selector(performSelector:)],
                   is(equalToBool(YES)));
}

- (void)testThatIncludesMessageMethodReturnsFalseForADifferentMessage {
    assertThatBool([self.subject includesMessageWithSelector:@selector(description)],
                   is(equalToBool(NO)));
}

- (void)testThatLastMessageReceivedMatchesSelectorOfFinalMessageSent {
    assertThat([self.subject lastMessage], is(equalTo(message(hash))));
}

@end




@interface CTDMessageListAfterReset : CTDMessageListBaseTestCase
@end
@implementation CTDMessageListAfterReset

- (void)setUp {
    [super setUp];
    [self.subject addMessageWithSelector:@selector(copy)];
    [self.subject addMessageWithSelector:@selector(performSelector:withObject:)];
    [self.subject reset];
}

- (void)testThatListIsEmpty {
    assertThat(self.subject.messageSelectors, isEmpty());
}

- (void)testThatLastMessageReturnsNil {
    assertThat([self.subject lastMessage], is(nilValue()));
}

- (void)testThatIncludesMessageMethodReturnsFalseForAllMessagesSent {
    assertThatBool([self.subject includesMessageWithSelector:@selector(copy)],
                   is(equalToBool(NO)));
    assertThatBool([self.subject includesMessageWithSelector:
                                     @selector(performSelector:withObject:)],
                   is(equalToBool(NO)));
}

@end




@interface CTDMessageListWhenNewMessagesAreSentAfterAReset
    : CTDMessageListBaseTestCase
@end
@implementation CTDMessageListWhenNewMessagesAreSentAfterAReset

- (void)setUp {
    [super setUp];
    [self.subject addMessageWithSelector:@selector(copy)];
    [self.subject addMessageWithSelector:@selector(performSelector:withObject:)];
    [self.subject reset];
    [self.subject addMessageWithSelector:@selector(description)];
    [self.subject addMessageWithSelector:@selector(performSelector:)];
}

- (void)testThatListIncludesAnEntryForEachMessageReceivedAfterTheReset {
    assertThat(self.subject.messageSelectors, hasCountOf(2));
}

- (void)testThatListIncludesAllSentSelectorsSentAfterTheReset {
    assertThat(self.subject.messageSelectors, hasItem(message(performSelector:)));
    assertThat(self.subject.messageSelectors, hasItem(message(description)));
}

- (void)testThatIncludesMessageMethodReturnsTrueForAllMessagesSentAfterTheReset {
    assertThatBool([self.subject includesMessageWithSelector:@selector(description)],
                   is(equalToBool(YES)));
    assertThatBool([self.subject includesMessageWithSelector:@selector(performSelector:)],
                   is(equalToBool(YES)));
}

- (void)testThatIncludesMessageMethodReturnsFalseForAllMessagesSentBeforeTheReset {
    assertThatBool([self.subject includesMessageWithSelector:@selector(copy)],
                   is(equalToBool(NO)));
    assertThatBool([self.subject includesMessageWithSelector:
                                     @selector(performSelector:withObject:)],
                   is(equalToBool(NO)));
}

@end
