// CTDTargetColor:
//     Application-domain color type: defines the set of target colors.
//
// Copyright 2014 Michael Hackett. All rights reserved.



typedef enum {
    CTDTargetColor_None,
    CTDTargetColor_White,
    CTDTargetColor_Red,
    CTDTargetColor_Green,
    CTDTargetColor_Blue
} CTDTargetColor;


@protocol CTDTargetColorSink <NSObject>
- (void)colorChangedTo:(CTDTargetColor)newColor;
@end
