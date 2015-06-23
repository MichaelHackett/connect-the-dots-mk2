// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDUIKitDrawingConfig.h"

#import "CTDPresentation/CTDColorPalette.h"
#import "CTDUIBridge/CTDUIKitColorPalette.h"



@implementation CTDUIKitDrawingConfig

- (id)init
{
    self = [super init];
    if (self) {
        // TODO: Load these values from a plist or XML file.
        //
        _dotDiameter = 65.0;
        _dotSelectionIndicatorColor = [UIColor purpleColor];
        _dotSelectionIndicatorThickness = 3.0;
        _dotSelectionIndicatorPadding = 15.0;
        _dotSelectionAnimationDuration = (CGFloat)0.12;
        _connectionLineWidth = 5.0;
        _connectionLineColor = [UIColor yellowColor];
        _colorPalette = [[CTDUIKitColorPalette alloc] initWithColorMap:@{
            CTDPaletteColor_InactiveDot: [UIColor whiteColor],
            CTDPaletteColor_DotType1:    [UIColor redColor],
            CTDPaletteColor_DotType2:    [UIColor greenColor],
            CTDPaletteColor_DotType3:    [UIColor blueColor]
        }];
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
        return (self.dotDiameter == other.dotDiameter) &&
               [self.dotSelectionIndicatorColor isEqual:other.dotSelectionIndicatorColor] &&
               (self.dotSelectionIndicatorThickness == other.dotSelectionIndicatorThickness) &&
               (self.dotSelectionIndicatorPadding == other.dotSelectionIndicatorPadding) &&
               (self.dotSelectionAnimationDuration == other.dotSelectionAnimationDuration) &&
               (self.connectionLineWidth == other.connectionLineWidth) &&
               [self.connectionLineColor isEqual:other.connectionLineColor] &&
               [self.colorPalette isEqual:other.colorPalette];
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
    hash = hash * prime + [@(self.dotDiameter) hash];
    hash = hash * prime + [self.dotSelectionIndicatorColor hash];
    hash = hash * prime + [@(self.dotSelectionIndicatorThickness) hash];
    hash = hash * prime + [@(self.dotSelectionIndicatorPadding) hash];
    hash = hash * prime + [@(self.dotSelectionAnimationDuration) hash];
    hash = hash * prime + [@(self.connectionLineWidth) hash];
    hash = hash * prime + [self.connectionLineColor hash];
    hash = hash * prime + [self.colorPalette hash];
    return hash;
}

@end
