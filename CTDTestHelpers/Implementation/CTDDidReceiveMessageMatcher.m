// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDDidReceiveMessageMatcher.h"

#import "CTDIntegerQuantity.h"
#import "CTDTestSpy.h"



@interface CTDMessageCountBaseMatcher : NSObject

@property (strong, readonly, nonatomic) CTDIntegerQuantity* referenceCount;

- (instancetype)initWithReferenceCount:(NSUInteger)referenceCount;

@end


@implementation CTDMessageCountBaseMatcher

- (instancetype)initWithReferenceCount:(NSUInteger)referenceCount
{
    self = [super init];
    if (self) {
        if (referenceCount > (NSUInteger)NSIntegerMax) {
            [NSException raise:NSInvalidArgumentException
                        format:@"reference count argument greater than max allowed %lu",
                               (unsigned long)NSIntegerMax];
        }
        _referenceCount = [[CTDIntegerQuantity alloc]
                           initWithMagnitude:(NSInteger)referenceCount
                                        unit:@"time"];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithReferenceCount:0];
}

@end





@interface CTDMessageCountExactMatcher : CTDMessageCountBaseMatcher <CTDMessageCountMatcher>
@end

@implementation CTDMessageCountExactMatcher

- (BOOL)matches:(NSUInteger)actualCount
{
    return (NSInteger)actualCount == self.referenceCount.magnitude;
}

- (void)describeTo:(id<HCDescription>)description
{
    [description appendText:@"exactly "];
    [description appendText:[self.referenceCount description]];
}

@end





@interface CTDMessageCountGreaterThanOrEqualMatcher
    : CTDMessageCountBaseMatcher <CTDMessageCountMatcher>
@end

@implementation CTDMessageCountGreaterThanOrEqualMatcher

- (BOOL)matches:(NSUInteger)actualCount
{
    return (NSInteger)actualCount >= self.referenceCount.magnitude;
}

- (void)describeTo:(id<HCDescription>)description
{
    [description appendText:@"at least "];
    [description appendText:[self.referenceCount description]];
}

@end





@interface CTDDidReceiveMessageMatcher : HCBaseMatcher
CTD_NO_DEFAULT_INIT
@end

@implementation CTDDidReceiveMessageMatcher
{
    SEL _selectorToMatch;
//    NSInvocation* _invocationToMatch;
    id<CTDMessageCountMatcher> _receptionCountMatcher;
}

- (instancetype)initWithMessageSelector:(SEL)selectorToMatch
                           countMatcher:(id<CTDMessageCountMatcher>)receptionCountMatcher
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



#pragma mark - Convenience functions

id CTD_receivedMessage(SEL selector, id<CTDMessageCountMatcher> countMatcher)
{
    return [[CTDDidReceiveMessageMatcher alloc]
            initWithMessageSelector:selector
            countMatcher:countMatcher];
}

id<CTDMessageCountMatcher> CTDMessageCountMatcher_exactly(NSUInteger expectedCount)
{
    return [[CTDMessageCountExactMatcher alloc] initWithReferenceCount:expectedCount];
}

id<CTDMessageCountMatcher> CTDMessageCountMatcher_exactlyOnce(void)
{
    return CTDMessageCountMatcher_exactly(1);
}

id<CTDMessageCountMatcher> CTDMessageCountMatcher_never(void)
{
    return CTDMessageCountMatcher_exactly(0);
}

id<CTDMessageCountMatcher> CTDMessageCountMatcher_atLeast(NSUInteger expectedCount)
{
    return [[CTDMessageCountGreaterThanOrEqualMatcher alloc]
            initWithReferenceCount:expectedCount];
}

id<CTDMessageCountMatcher> CTDMessageCountMatcher_atLeastOnce(void)
{
    return CTDMessageCountMatcher_atLeast(1);
}
