// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDPoint.h"


static CTDPoint* ORIGIN = nil;


@implementation CTDPoint

#pragma mark - Creation and initialization

+ (void)initialize
{
    ORIGIN = [[self alloc] initWithX:0.0 y:0.0];
}

// Designated initializer
- (instancetype)initWithX:(CTDPointCoordinate)x
                        y:(CTDPointCoordinate)y
{
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
    }
    return self;
}

// Default initializer
- (instancetype)init
{
    return [self initWithX:0.0 y:0.0];
}

+ (instancetype)x:(CTDPointCoordinate)x
                y:(CTDPointCoordinate)y
{
    return [[self alloc] initWithX:x y:y];
}

// Return singleton representing origin (0,0) point.
+ (instancetype)origin
{
    return ORIGIN;
}


#pragma mark - NSCopying

- (id)copyWithZone:(__unused NSZone*)zone
{
    // CTDPoints are immutable, so just use the same instance and bump the
    // retain count (done automatically by ARC).
    if ([self isMemberOfClass:[CTDPoint class]]) {
        return self;
    }
    // Else, make a fresh instance with the same values.
    return [[[self class] alloc] initWithX:self.x y:self.y];
}


#pragma mark - Equality and hashing

- (BOOL)isEqual:(id)object
{
    if (object == self) { return YES; }
    if (object && [object isMemberOfClass:[CTDPoint class]]) {
        return [self isEqualToPoint:(CTDPoint*)object];
    }
    return NO;
}

- (BOOL)isEqualToPoint:(CTDPoint*)otherPoint
{
    if (otherPoint.x == self.x && otherPoint.y == self.y) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash
{
    // Using algorithm from Effective Java, except using NSNumber's hash function
    // for the double values. (Could convert directly to bits to be faster, but
    // this may never be used so not worrying about speed for now.)
    static const NSUInteger prime = 37;
    return ((17 + [@(self.x) hash]) * prime) + [@(self.y) hash];
}


#pragma mark - String representations

- (NSString*)description
{
    return [NSString stringWithFormat:@"(%g,%g)", self.x, self.y];
}

- (NSString*)debugDescription
{
    return [NSString stringWithFormat:@"CTDPoint %@", self];
}

@end
