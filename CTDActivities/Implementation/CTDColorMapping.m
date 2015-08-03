// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDColorMapping.h"


CTDPaletteColorLabel const CTDPaletteColor_InactiveDot = @"Inactive dot";
CTDPaletteColorLabel const CTDPaletteColor_DotType1 = @"Dot type 1";
CTDPaletteColorLabel const CTDPaletteColor_DotType2 = @"Dot type 2";
CTDPaletteColorLabel const CTDPaletteColor_DotType3 = @"Dot type 3";


CTDPaletteColorLabel paletteColorForDotColor(CTDDotColor dotColor)
{
    switch (dotColor) {
        case CTDDotColor_Red:   return CTDPaletteColor_DotType1;
        case CTDDotColor_Green: return CTDPaletteColor_DotType2;
        case CTDDotColor_Blue:  return CTDPaletteColor_DotType3;
        default: return CTDPaletteColor_InactiveDot;
    }
}
