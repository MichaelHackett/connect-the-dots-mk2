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


- (CTDPoint*)connectionPoint
{
    CTDUIKitDotView* strongDotView = _dotView;
    return [CTDPoint fromCGPoint:[strongDotView connectionPoint]];
}

- (void)changeDotColorTo:(CTDPaletteColorLabel)newDotColor
{
    CTDUIKitDotView* strongDotView = _dotView;
    strongDotView.dotColor = _colorPalette[newDotColor];
}

- (void)showSelectionIndicator
{
    CTDUIKitDotView* strongDotView = _dotView;
    strongDotView.selectionIndicatorIsVisible = YES;
}

- (void)hideSelectionIndicator
{
    CTDUIKitDotView* strongDotView = _dotView;
    strongDotView.selectionIndicatorIsVisible = NO;
}



#pragma mark CTDTouchable protocol


- (BOOL)containsTouchLocation:(CTDPoint*)touchLocation
{
    CTDUIKitDotView* dotView = _dotView;
    CGPoint localTouchLocation = [dotView convertPoint:[touchLocation asCGPoint]
                                              fromView:nil];
    return [dotView dotContainsPoint:localTouchLocation];
}

@end
