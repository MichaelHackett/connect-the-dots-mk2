// CTDColorPalette:
//     Defines identifiers for the rendering colors that are relevant to the
//     presentation layer. The NativeUI adapter will map these to suitable
//     native-platform, consistently across all uses.
//
// Strings were chosen for the palette keys as this permits extension without
// worry of collision between indexes. (Numerical indices require coordination
// if two separate entities are using them, e.g., an app and a Presentation
// library element, whereas with strings, one can use prefixes, for example,
// to avoid collisions.)
//
// The downside of strings is that it is harder to ensure that all palette
// entries are filled in the UIKit initialization code, so the palette needs to
// either support the specification of a *default* color to use when there is
// no element in the table (and to log such occurrences), or to raise an
// exception (fail fast, so developer knows of error).
//
// Copyright 2014-5 Michael Hackett. All rights reserved.


//
// Palette color labels
//
typedef NSString* CTDPaletteColorLabel;
extern CTDPaletteColorLabel const CTDPaletteColor_InactiveDot;
extern CTDPaletteColorLabel const CTDPaletteColor_DotType1;
extern CTDPaletteColorLabel const CTDPaletteColor_DotType2;
extern CTDPaletteColorLabel const CTDPaletteColor_DotType3;
