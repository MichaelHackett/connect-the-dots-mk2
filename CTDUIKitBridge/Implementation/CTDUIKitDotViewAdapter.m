// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitDotViewAdapter.h"

#import "CTDPoint+CGConversion.h"
#import "CTDUIKitColorPalette.h"
#import "CTDUIKitDotView.h"
#import "CTDUtility/CTDNotificationReceiver.h"
#import "CTDUtility/CTDPoint.h"



// Notification definitions
NSString * const CTDDotViewDiscardedNotification = @"CTDDotViewDiscardedNotification";




@implementation CTDUIKitDotViewAdapter
{
    __weak CTDUIKitDotView* _dotView;
    CTDUIKitColorPalette* _colorPalette;
    __weak id<CTDNotificationReceiver> _notificationReceiver;
}


#pragma mark Initialization


- (instancetype)initWithDotView:(CTDUIKitDotView*)dotView
                   colorPalette:(CTDUIKitColorPalette*)colorPalette
           notificationReceiver:(id<CTDNotificationReceiver>)notificationReceiver
{
    self = [super init];
    if (self) {
        _dotView = dotView;
        _colorPalette = colorPalette;
        _notificationReceiver = notificationReceiver;
    }
    return self;
}



#pragma mark CTDDotRenderer protocol


- (CTDPoint*)dotConnectionPoint
{
    ctd_strongify(_dotView, dotView);
    return [CTDPoint fromCGPoint:[dotView connectionPoint]];
}

- (void)setDotCenterPosition:(CTDPoint*)centerPosition
{
    ctd_strongify(_dotView, dotView);
    dotView.center = [centerPosition asCGPoint];
}

- (void)setDotColor:(CTDPaletteColorLabel)newDotColor
{
    ctd_strongify(_dotView, dotView);
    dotView.dotColor = _colorPalette[newDotColor];
}

- (void)setVisible:(BOOL)visible
{
    ctd_strongify(_dotView, dotView);
    dotView.hidden = !visible;
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

- (void)discardRendering
{
    ctd_strongify(_notificationReceiver, notificationReceiver);
    [notificationReceiver receiveNotification:CTDDotViewDiscardedNotification
                                   fromSender:self
                                     withInfo:nil];

    ctd_strongify(_dotView, dotView);
    _dotView = nil;
    [dotView removeFromSuperview];
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
