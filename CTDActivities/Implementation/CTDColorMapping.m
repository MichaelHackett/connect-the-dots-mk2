// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDColorMapping.h"


CTDPaletteColorLabel paletteColorForDotColor(CTDDotColor dotColor)
{
    switch (dotColor) {
        case CTDDotColor_Red:   return CTDPaletteColor_DotType1;
        case CTDDotColor_Green: return CTDPaletteColor_DotType2;
        case CTDDotColor_Blue:  return CTDPaletteColor_DotType3;
        default: return CTDPaletteColor_InactiveDot;
    }
}
