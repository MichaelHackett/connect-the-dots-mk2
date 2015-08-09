// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitDotViewAdapter.h"

#import "CTDPoint+CGConversion.h"
#import "CTDUIKitColorPalette.h"
#import "CTDUIKitDotView.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDUIKitDotViewAdapter
{
    __weak CTDUIKitDotView* _dotView;
    CTDUIKitColorPalette* _colorPalette;
}


#pragma mark Initialization


- (instancetype)initWithDotView:(CTDUIKitDotView*)dotView
                   colorPalette:(CTDUIKitColorPalette*)colorPalette
{
    self = [super init];
    if (self) {
        _dotView = dotView;
        _colorPalette = colorPalette;
    }
    return self;
}



#pragma mark CTDDotRenderer protocol


- (CTDPoint*)dotConnectionPoint
{
    ctd_strongify(_dotView, dotView);
    return [CTDPoint fromCGPoint:[dotView connectionPoint]];
}

- (void)setDotColor:(CTDPaletteColorLabel)newDotColor
{
    ctd_strongify(_dotView, dotView);
    dotView.dotColor = _colorPalette[newDotColor];
}

- (void)showSelectionIndicator
{
    ctd_strongify(_dotView, dotView);
    dotView.selectionIndicatorIsVisible = YES;
}

- (void)hideSelectionIndicator
{
    ctd_strongify(_dotView, dotView);
    dotView.selectionIndicatorIsVisible = NO;
}



#pragma mark CTDTouchable protocol


- (BOOL)containsTouchLocation:(CTDPoint*)touchLocation
{
    ctd_strongify(_dotView, dotView);
    CGPoint localTouchLocation = [dotView convertPoint:[touchLocation asCGPoint]
                                              fromView:nil];
    return [dotView dotContainsPoint:localTouchLocation];
}

@end
