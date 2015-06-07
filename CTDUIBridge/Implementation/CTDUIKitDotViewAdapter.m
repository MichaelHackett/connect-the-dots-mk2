// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitDotViewAdapter.h"

#import "CTDPoint+CGConversion.h"
#import "CTDUIKitColorPalette.h"
#import "CTDUIKitDotView.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDUIKitDotViewAdapter
{
    CTDUIKitDotView* _dotView;
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
    return [CTDPoint fromCGPoint:[_dotView connectionPoint]];
}

- (void)changeDotColorTo:(CTDPaletteColorLabel)newDotColor
{
    _dotView.dotColor = _colorPalette[newDotColor];
}

- (void)showSelectionIndicator
{
    _dotView.selectionIndicatorIsVisible = YES;
}

- (void)hideSelectionIndicator
{
    _dotView.selectionIndicatorIsVisible = NO;
}



#pragma mark CTDTouchable protocol


- (BOOL)containsTouchLocation:(CTDPoint*)touchLocation
{
    return [_dotView containsTouchLocation:[touchLocation asCGPoint]];
}

@end
