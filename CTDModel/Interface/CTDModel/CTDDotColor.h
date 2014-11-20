// CTDDotColor:
//     Application-domain color type: defines the set of dot colors.
//
// Copyright 2014 Michael Hackett. All rights reserved.



typedef enum {
    CTDDotColor_None,
    CTDDotColor_White,
    CTDDotColor_Red,
    CTDDotColor_Green,
    CTDDotColor_Blue
} CTDDotColor;


@protocol CTDDotColorSink <NSObject>
- (void)colorChangedTo:(CTDDotColor)newColor;
@end
