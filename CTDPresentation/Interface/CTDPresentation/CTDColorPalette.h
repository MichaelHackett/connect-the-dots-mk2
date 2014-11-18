// CTDColorPalette:
//     Defines identifiers for the rendering colors that are relevant to the
//     presentation layer. The NativeUI adapter will map these to suitable
//     native-platform, consistently across all uses.
//
// Note that the name of the enumeration type is "CTDPaletteColor", as it
// describes a single instance of a palette color, but the file is named with
// respect to the collection colors, which forms the "color palette" for the
// application.
//
// Copyright 2014 Michael Hackett. All rights reserved.


typedef enum {

    CTDPALETTE_WHITE_TARGET,
    CTDPALETTE_RED_TARGET,
    CTDPALETTE_GREEN_TARGET,
    CTDPALETTE_BLUE_TARGET

} CTDPaletteColor;
