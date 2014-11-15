// CTDTargetColor:
//     Application-domain color type: defines the set of target colors.
//
// Copyright 2014 Michael Hackett. All rights reserved.



typedef enum {
    CTDTARGETCOLOR_NONE,
    CTDTARGETCOLOR_WHITE,
    CTDTARGETCOLOR_RED,
    CTDTARGETCOLOR_GREEN,
    CTDTARGETCOLOR_BLUE
} CTDTargetColor;


@protocol CTDTargetColorSink <NSObject>
- (void)colorChangedTo:(CTDTargetColor)newColor;
@end
