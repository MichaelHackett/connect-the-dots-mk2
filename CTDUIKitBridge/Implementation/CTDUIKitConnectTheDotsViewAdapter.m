// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectTheDotsViewAdapter.h"

#import "CTDPoint+CGConversion.h"
#import "CTDUIKitColorPalette.h"
#import "CTDUIKitConnectTheDotsView.h"
#import "CTDUIKitDotView.h"
#import "CTDUIKitDotViewAdapter.h"
#import "CTDUIKitLineView.h"
#import "CTDUIKitLineViewAdapter.h"

#import "CTDInteraction/CTDMutableTouchToElementMapper.h"



@implementation CTDUIKitConnectTheDotsViewAdapter
{
    __weak CTDUIKitConnectTheDotsView* _connectTheDotsView;
    CTDUIKitColorPalette* _colorPalette;
    id<CTDMutableTouchToElementMapper> _touchToDotMapper;
}

- (instancetype)initWithConnectTheDotsView:(CTDUIKitConnectTheDotsView*)connectTheDotsView
                              colorPalette:(CTDUIKitColorPalette*)colorPalette
                          touchToDotMapper:(id<CTDMutableTouchToElementMapper>)touchToDotMapper;
{
    self = [super init];
    if (self) {
        _connectTheDotsView = connectTheDotsView;
        _colorPalette = [colorPalette copy];
        _touchToDotMapper = touchToDotMapper;
    }
    return self;
}



#pragma mark CTDTrialRenderer protocol


- (id<CTDDotRenderer, CTDTouchable>)newRendererForDot
{
    CTDUIKitConnectTheDotsView* ctdView = _connectTheDotsView;
    if (!ctdView) {
        return nil;
    }

    id<CTDDotRenderer, CTDTouchable> dotViewAdapter =
        [[CTDUIKitDotViewAdapter alloc]
         initWithDotView:[ctdView newDotCenteredAt:CGPointZero]
            colorPalette:_colorPalette];
    [dotViewAdapter setVisible:NO];
    [_touchToDotMapper mapTouchable:dotViewAdapter
                         toActuator:dotViewAdapter]; // TEMP until I know what this should be

    return dotViewAdapter;
}

- (id<CTDDotConnectionRenderer>)newRendererForDotConnection
{
    CTDUIKitConnectTheDotsView* ctdView = _connectTheDotsView;
    if (!ctdView) {
        return nil;
    }
    return [[CTDUIKitLineViewAdapter alloc] initWithLineView:[ctdView newConnection]];
}



#pragma mark CTDTouchToPointMapper protocol


- (CTDPoint*)pointAtTouchLocation:(CTDPoint*)touchLocation
{
    CTDUIKitConnectTheDotsView* ctdView = _connectTheDotsView;
    CGPoint localPoint = [ctdView convertPoint:[touchLocation asCGPoint]
                                      fromView:nil];

    if (!CGRectContainsPoint(ctdView.bounds, localPoint)) {
        return nil;  // Point is outside view
    }

    return [CTDPoint fromCGPoint:localPoint];
}

@end
