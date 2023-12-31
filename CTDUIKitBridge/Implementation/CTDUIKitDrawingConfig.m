// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDUIKitDrawingConfig.h"

#import "CTDUIKitColorPalette.h"



@implementation CTDUIKitDrawingConfig

- (id)init
{
    self = [super init];
    if (self) {
        // Default values
        _colorPalette = nil;
    }
    return self;
}



#pragma mark NSCopying protocol


- (id)copyWithZone:(__unused NSZone*)zone
{
    // Configs are immutable, so just use the same instance and bump the
    // retain count (done automatically by ARC).
    if ([self isMemberOfClass:[CTDUIKitDrawingConfig class]]) {
        return self;
    }
    // Else, make a fresh instance with the same values.
    return [[[self class] alloc] init];
}



#pragma mark Equality and hashing


- (BOOL)isEqual:(id)object
{
    if (object == self) { return YES; }
    if (object && [object isMemberOfClass:[CTDUIKitDrawingConfig class]]) {
        CTDUIKitDrawingConfig* other = (CTDUIKitDrawingConfig*)object;
        return [self.colorPalette isEqual:other.colorPalette];
    }
    return NO;
}

- (NSUInteger)hash
{
    // Using algorithm from Effective Java, except using NSNumber's hash function
    // for the double values. (Could convert directly to bits to be faster, but
    // this may never be used so not worrying about speed for now.)
    static const NSUInteger prime = 31;
    NSUInteger hash = 17;
    hash = hash * prime + [self.colorPalette hash];
    return hash;
}

@end
