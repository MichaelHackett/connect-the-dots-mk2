// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDDidReceiveMessageMatcher.h"

#import "CTDIntegerQuantity.h"
#import "CTDTestSpy.h"

#import <OCHamcrest/HCBaseMatcher.h>




@interface CTDDidReceiveMessageMatcher : HCBaseMatcher
CTD_NO_DEFAULT_INIT
@end

@implementation CTDDidReceiveMessageMatcher
{
    SEL _selectorToMatch;
//    NSInvocation* _invocationToMatch;
    id<CTDOccurrenceCountMatcher> _receptionCountMatcher;
}

- (instancetype)initWithMessageSelector:(SEL)selectorToMatch
                           countMatcher:(id<CTDOccurrenceCountMatcher>)receptionCountMatcher
{
    self = [super init];
    if (self) {
        _selectorToMatch = selectorToMatch;
//        NSMethodSignature* sig = [NSObject instanceMethodSignatureForSelector:selectorToMatch];
//        _invocationToMatch = [NSInvocation invocationWithMethodSignature:sig];
        _receptionCountMatcher = receptionCountMatcher;
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD

- (BOOL)matches:(id)item
{
    if (![item conformsToProtocol:@protocol(CTDTestSpy)]) {
        return NO;
    }
    id<CTDTestSpy> spy = (id<CTDTestSpy>)item;
    return ([_receptionCountMatcher matches:
             [spy countOfMessagesReceivedWithSelector:_selectorToMatch]]);
}

- (void)describeTo:(id<HCDescription>)description
{
    [description appendText:
        [NSString stringWithFormat:@"object to have received '%@' message ",
         NSStringFromSelector(_selectorToMatch)]];
    [_receptionCountMatcher describeTo:description];
}

- (void)describeMismatchOf:(id)item to:(id<HCDescription>)mismatchDescription
{
    if (![item conformsToProtocol:@protocol(CTDTestSpy)]) {
        [mismatchDescription appendText:@"object was not a test spy"];
    } else {
        id<CTDTestSpy> spy = (id<CTDTestSpy>)item;
        NSUInteger matchingCount = [spy countOfMessagesReceivedWithSelector:_selectorToMatch];
        if (![_receptionCountMatcher matches:matchingCount]) {
            [mismatchDescription appendText:
             [NSString stringWithFormat:@"it received the message %u times",
                                        matchingCount]];
        }
    }
}

@end



#pragma mark - Factory functions


id CTD_receivedMessage(SEL selector, id<CTDOccurrenceCountMatcher> countMatcher)
{
    return [[CTDDidReceiveMessageMatcher alloc]
            initWithMessageSelector:selector
            countMatcher:countMatcher];
}
