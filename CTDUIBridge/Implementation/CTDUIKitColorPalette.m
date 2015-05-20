// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitColorPalette.h"



@implementation CTDUIKitColorPalette
{
    NSDictionary* _colorMap;
}

- (instancetype)initWithColorMap:(NSDictionary*)colorMap
{
    self = [super init];
    if (self) {
        _colorMap = [colorMap copy];
    }
    return self;
}

// Throws an exception when no entry is found for the specified palette key,
// as this is assumed to be either a configuration error (forgetting to
// include the entry when building the palette) or a typo at the call site.
// Preferring to fail fast and alert the developer rather than simply logging
// and having strange effects as a result of a nil color returned.
- (UIColor*)colorFor:(id)paletteColorKey
{
    UIColor* color = [_colorMap objectForKey:paletteColorKey];
    if (!color) {
        [NSException raise:NSInvalidArgumentException
                    format:@"No palette entry matching key:'%@' found", paletteColorKey];
    }
    return color;
}

- (UIColor*)objectForKeyedSubscript:(id)paletteColorKey
{
    return [self colorFor:paletteColorKey];
}



#pragma mark NSCopying protocol


- (id)copyWithZone:(__unused NSZone*)zone
{
    // Palettes are (currently) immutable, so just use the same instance and
    // bump the retain count (done automatically by ARC).
    if ([self isMemberOfClass:[CTDUIKitColorPalette class]]) {
        return self;
    }
    // Else, make a fresh instance with the same values.
    return [[[self class] alloc] initWithColorMap:_colorMap];
}



#pragma mark Equality and hashing


- (BOOL)isEqual:(id)object
{
    if (object == self) { return YES; }
    if (object && [object isMemberOfClass:[CTDUIKitColorPalette class]]) {
        CTDUIKitColorPalette* other = (CTDUIKitColorPalette*)object;
        return [_colorMap isEqualToDictionary:other->_colorMap];
    }
    return NO;
}

- (NSUInteger)hash
{
    // Hash algorithm from Effective Java:
    static const NSUInteger prime = 31;
    __block NSUInteger hash = 17;
    [_colorMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, __unused BOOL* stop) {
        hash = ((hash * prime) + [key hash]) * prime + [obj hash];
    }];
    return hash;
}

@end
