// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectTheDotsViewAdapter.h"

#import "CTDPoint+CGConversion.h"
#import "CTDUIKitColorPalette.h"
#import "CTDUIKitConnectTheDotsView.h"
#import "CTDUIKitDotView.h"
#import "CTDUIKitDotViewAdapter.h"
#import "CTDUIKitLineView.h"
#import "CTDUIKitLineViewAdapter.h"



@implementation CTDUIKitConnectTheDotsViewAdapter
{
    __weak CTDUIKitConnectTheDotsView* _connectTheDotsView;
    CTDUIKitColorPalette* _colorPalette;
}

- (instancetype)initWithConnectTheDotsView:(CTDUIKitConnectTheDotsView*)connectTheDotsView
                              colorPalette:(CTDUIKitColorPalette*)colorPalette
{
    self = [super init];
    if (self) {
        _connectTheDotsView = connectTheDotsView;
        _colorPalette = [colorPalette copy];
    }
    return self;
}



#pragma mark CTDTrialRenderer protocol


- (id<CTDDotRenderer, CTDTouchable>)
      newDotRenderingCenteredAt:(CTDPoint*)centerPosition
               withInitialColor:(CTDPaletteColorLabel)dotColor
{
    CTDUIKitConnectTheDotsView* ctdView = _connectTheDotsView;
    if (!ctdView) {
        return nil;
    }

    id<CTDDotRenderer, CTDTouchable> dotViewAdapter =
        [[CTDUIKitDotViewAdapter alloc]
         initWithDotView:[ctdView newDotCenteredAt:[centerPosition asCGPoint]]
            colorPalette:_colorPalette];
    [dotViewAdapter changeDotColorTo:dotColor];

    return dotViewAdapter;
}

- (id<CTDDotConnectionRenderer>)
      newDotConnectionRenderingWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                                  secondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    CTDUIKitConnectTheDotsView* ctdView = _connectTheDotsView;
    if (!ctdView) {
        return nil;
    }

    id<CTDDotConnectionRenderer> lineViewAdapter =
        [[CTDUIKitLineViewAdapter alloc] initWithLineView:[ctdView newConnection]];
    [lineViewAdapter setFirstEndpointPosition:firstEndpointPosition];
    [lineViewAdapter setSecondEndpointPosition:secondEndpointPosition];

    return lineViewAdapter;
}



#pragma mark CTDTouchToPointMapper protocol


- (CTDPoint*)pointAtTouchLocation:(CTDPoint*)touchLocation
{
    CTDUIKitConnectTheDotsView* ctdView = _connectTheDotsView;
    CGPoint localPoint = [ctdView convertPoint:[touchLocation asCGPoint]
                                      fromView:nil];
    return [CTDPoint fromCGPoint:localPoint];
}

@end
