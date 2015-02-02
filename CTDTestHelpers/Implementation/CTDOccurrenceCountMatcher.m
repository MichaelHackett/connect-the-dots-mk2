// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDOccurrenceCountMatcher.h"

#import "CTDIntegerQuantity.h"




@interface CTDOccurrenceCountBaseMatcher : NSObject

@property (strong, readonly, nonatomic) CTDIntegerQuantity* referenceCount;

- (instancetype)initWithReferenceCount:(NSUInteger)referenceCount;

@end


@implementation CTDOccurrenceCountBaseMatcher

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





@interface CTDOccurrenceCountExactMatcher
    : CTDOccurrenceCountBaseMatcher <CTDOccurrenceCountMatcher>
@end

@implementation CTDOccurrenceCountExactMatcher

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





@interface CTDOccurrenceCountGreaterThanOrEqualMatcher
    : CTDOccurrenceCountBaseMatcher <CTDOccurrenceCountMatcher>
@end

@implementation CTDOccurrenceCountGreaterThanOrEqualMatcher

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




#pragma mark - Factory functions


id<CTDOccurrenceCountMatcher> CTDOccurrenceCountMatcher_exactly(NSUInteger expectedCount)
{
    return [[CTDOccurrenceCountExactMatcher alloc] initWithReferenceCount:expectedCount];
}

id<CTDOccurrenceCountMatcher> CTDOccurrenceCountMatcher_exactlyOnce(void)
{
    return CTDOccurrenceCountMatcher_exactly(1);
}

id<CTDOccurrenceCountMatcher> CTDOccurrenceCountMatcher_never(void)
{
    return CTDOccurrenceCountMatcher_exactly(0);
}

id<CTDOccurrenceCountMatcher> CTDOccurrenceCountMatcher_atLeast(NSUInteger expectedCount)
{
    return [[CTDOccurrenceCountGreaterThanOrEqualMatcher alloc]
            initWithReferenceCount:expectedCount];
}

id<CTDOccurrenceCountMatcher> CTDOccurrenceCountMatcher_atLeastOnce(void)
{
    return CTDOccurrenceCountMatcher_atLeast(1);
}
