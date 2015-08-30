// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDDotPair.h"

#import "CTDUtility/CTDPoint.h"



@implementation CTDDotPair


#pragma mark Initialization


- (instancetype)initWithColor:(CTDDotColor)color
                startPosition:(CTDPoint*)startPosition
                  endPosition:(CTDPoint*)endPosition
{
    self = [super init];
    if (self)
    {
        _color = color;
        _startPosition = startPosition;
        _endPosition = endPosition;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark NSCopying protocol


- (id)copyWithZone:(__unused NSZone*)zone
{
    // CTDPoints are immutable, so just use the same instance and bump the
    // retain count (done automatically by ARC).
    if ([self isMemberOfClass:[CTDDotPair class]])
    {
        return self;
    }
    // Else, make a fresh instance with the same values.
    return [[[self class] alloc] initWithColor:self.color
                                 startPosition:self.startPosition
                                   endPosition:self.endPosition];
}



#pragma mark Equality and hashing


- (BOOL)isEqual:(id)object
{
    if (object == self) { return YES; }
    if (object && [object isMemberOfClass:[CTDDotPair class]])
    {
        return [self isEqualToDotPair:(CTDDotPair*)object];
    }
    return NO;
}

- (BOOL)isEqualToDotPair:(CTDDotPair*)otherDotPair
{
    return (otherDotPair.color == self.color &&
            otherDotPair.startPosition == self.startPosition &&
            otherDotPair.endPosition == self.endPosition);
}

- (NSUInteger)hash
{
    // Using algorithm from Effective Java, except using NSNumber's hash function
    // for the double values. (Could convert directly to bits to be faster, but
    // this may never be used so not worrying about speed for now.)
    static const NSUInteger prime = 37;
    return ((((17 + [@(self.color) hash]) * prime) +
             [self.startPosition hash]) * prime) +
           [self.endPosition hash];
}



#pragma mark String representations


- (NSString*)description
{
    return [NSString stringWithFormat:@"color:%u from:%@ to:%@",
            self.color, self.startPosition, self.endPosition];
}

- (NSString*)debugDescription
{
    return [NSString stringWithFormat:@"CTDDotPair %@", self];
}

@end
