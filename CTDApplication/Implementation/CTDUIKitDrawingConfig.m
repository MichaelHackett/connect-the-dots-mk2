// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDUIKitDrawingConfig.h"




@implementation CTDUIKitDrawingConfig
{
    NSDictionary* _colorPalette;
}

- (id)init
{
    self = [super init];
    if (self) {
        // TODO: Load these values from a plist or XML file.
        //
        _connectionLineWidth = 5.0;
        _connectionLineColor = [[UIColor yellowColor] CGColor];
        _colorPalette = @{
            @(CTDPaletteColor_WhiteDot):   [UIColor whiteColor],
            @(CTDPaletteColor_RedDot):     [UIColor redColor],
            @(CTDPaletteColor_GreenDot):   [UIColor greenColor],
            @(CTDPaletteColor_BlueDot):    [UIColor blueColor]
        };
    }
    return self;
}

- (UIColor*)colorFor:(CTDPaletteColor)paletteColor
{
    return [_colorPalette objectForKey:@(paletteColor)];
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
        return (self.connectionLineWidth == other.connectionLineWidth) &&
               CGColorEqualToColor(self.connectionLineColor,
                                   other.connectionLineColor) &&
               [super isEqual:object];
    }
    return NO;
}

- (NSUInteger)hash
{
    // Using algorithm from Effective Java, except using NSNumber's hash function
    // for the double values. (Could convert directly to bits to be faster, but
    // this may never be used so not worrying about speed for now.)
    static const NSUInteger prime = 31;
    return (17 * prime + [@(self.connectionLineWidth) hash]) * prime
           + [[UIColor colorWithCGColor:self.connectionLineColor] hash];
}

@end
