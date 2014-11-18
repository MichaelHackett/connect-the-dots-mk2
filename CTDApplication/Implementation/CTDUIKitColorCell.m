// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDUIKitColorCell.h"

#import "CTDPoint+CGConversion.h"




@implementation CTDUIKitColorCell
{
    UIColor* _cellColor;
    UIColor* _highlightColor;
    UIView* _contentView;
}

- (instancetype)initWithColor:(UIColor*)cellColor
{
    CGFloat hue, saturation, brightness, alpha;

    self = [super init];
    if (self) {
        _cellColor = [cellColor copy];
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        _contentView.backgroundColor = _cellColor;

        if ([cellColor getHue:&hue
                   saturation:&saturation
                   brightness:&brightness
                   alpha:&alpha])
        {
            _highlightColor = [UIColor colorWithHue:hue
                                         saturation:(saturation * 0.5f)
                                         brightness:(brightness * 1.2f)
                                              alpha:alpha];
        } else {
            _highlightColor = [UIColor whiteColor];
        }
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (UIView*)toolbarCellContentView
{
    return _contentView;
}




#pragma mark CTDSelectionRenderer protocol


- (void)showSelectionIndicator
{
    _contentView.backgroundColor = _highlightColor;
}

- (void)hideSelectionIndicator
{
    _contentView.backgroundColor = _cellColor;
}




#pragma mark CTDTouchable protocol


- (BOOL)containsTouchLocation:(CTDPoint*)touchLocation
{
    // FIXME: Cheating! Makes assumptions about the cell view's position in
    // the view hierarchy, relative to the main view controller's container.
    // This'll get us going, but it really shouldn't be left like this.
    // (Suggestion: Add remappers that wrap the cell and convert between
    // coordinate systems for the CTDTouchable messages, passing others
    // unchanged.)

    UIView* toolbarView = _contentView.superview;
    if (toolbarView) {
        CGPoint localPoint = [toolbarView convertPoint:[touchLocation asCGPoint]
                                              fromView:toolbarView.superview];
        // TODO: Expand touch-sensitive area slightly beyond the bounds of the visual frame?
        return (BOOL)CGRectContainsPoint(_contentView.frame, localPoint);
    }
    return NO;
}

@end
