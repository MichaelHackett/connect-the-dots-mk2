// CTDUIKitColorPalette:
//     Maps application-specific color identifiers to UIColors for the UIKit
//     rendering code.
//
// The palette color keys can be any value types, though it is suggested that
// NSStrings be used, to make it easy to add new colors without having to
// rejig the existing keys, and to provide a built-in description for debugging
// or logging. This may, at some point, become enforced (once a good location
// for such generic UI-Bridge-interface elements is chosen).
//
// Copyright 2015 Michael Hackett. All rights reserved.


@interface CTDUIKitColorPalette : NSObject

- (instancetype)initWithColorMap:(NSDictionary*)colorMap;

// - (void)setColor:(UIColor*) for:(id)paletteColorKey; // needed?
- (UIColor*)colorFor:(id)paletteColorKey;

// Subscript notation support
- (UIColor*)objectForKeyedSubscript:(id)paletteColorKey;

@end
