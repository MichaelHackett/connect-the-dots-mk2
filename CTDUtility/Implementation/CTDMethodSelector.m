// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDMethodSelector.h"


@implementation CTDMethodSelector
{
    SEL _rawSelector;
}

- (instancetype)initWithRawSelector:(SEL)rawSelector
{
    self = [super init];
    if (self) {
        _rawSelector = rawSelector;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD;



#pragma mark NSCopying

- (id)copyWithZone:(__unused NSZone*)zone
{
    // CTDMethodSelectors are immutable, so just use the same instance and
    // bump the retain count (done automatically by ARC).
    if ([self isMemberOfClass:[CTDMethodSelector class]]) {
        return self;
    }
    // Else, make a fresh instance with the same values.
    return [[[self class] alloc] initWithRawSelector:self.rawSelector];
}


#pragma mark Equality and hashing

- (BOOL)isEqual:(id)object
{
    if (object == self) { return YES; }
    if (object && [object isMemberOfClass:[CTDMethodSelector class]]) {
        return [self isEqualToRawSelector:((CTDMethodSelector*)object).rawSelector];
    }
    return NO;
}

- (BOOL)isEqualToRawSelector:(__unused SEL)rawSelector
{
    return rawSelector == self.rawSelector;
}

- (NSUInteger)hash
{
    // Using algorithm from Effective Java, except using NSValue's hash function
    // for the selector (treated as a pointer).
    static const NSUInteger prime = 37;
    return (17 + [[NSValue valueWithPointer:self.rawSelector] hash]) * prime;
}


#pragma mark String representations

- (NSString*)description
{
    return NSStringFromSelector(self.rawSelector);
}

- (NSString*)debugDescription
{
    return [NSString stringWithFormat:@"CTDMethodSelector(%@)", self];
}

@end
