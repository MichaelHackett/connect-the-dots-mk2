// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDUIKitColorCell.h"

#import "CTDPoint+CGConversion.h"



@implementation CTDUIKitColorCell
{
    BOOL _selected;
    BOOL _activated;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _selected = NO;
        _activated = NO;
    }
    return self;
}

#pragma mark CTDSelectionRenderer protocol


- (void)showSelectionIndicator
{
    self.backgroundColor = self.colorWhenSelected;
    _selected = YES;
}

- (void)hideSelectionIndicator
{
    _selected = NO;
    if (!_activated)
    {
        self.backgroundColor = self.colorWhenNotSelected;
    }
}

- (void)showActivationIndicator
{
    // TODO: Different effect for activation
    self.backgroundColor = self.colorWhenSelected;
    _activated = YES;
}

- (void)hideActivationIndicator
{
    _activated = NO;
    if (!_selected)
    {
        self.backgroundColor = self.colorWhenNotSelected;
    }
}



#pragma mark CTDTouchable protocol


- (BOOL)containsTouchLocation:(__unused CTDPoint*)touchLocation
{
    // FIXME: Cheating! Makes assumptions about the cell view's position in
    // the view hierarchy, relative to the main view controller's container.
    // This'll get us going, but it really shouldn't be left like this.
    // (Suggestion: Add remappers that wrap the cell and convert between
    // coordinate systems for the CTDTouchable messages, passing others
    // unchanged.)

    UIView* toolbarView = self.superview;
    if (toolbarView) {
        CGPoint localPoint = [toolbarView convertPoint:[touchLocation asCGPoint]
                                              fromView:toolbarView.superview];
        // TODO: Expand touch-sensitive area slightly beyond the bounds of the visual frame?
        return (BOOL)CGRectContainsPoint(self.frame, localPoint);
    }
    return NO;
}

@end
