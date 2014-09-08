// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDUIKitToolbar.h"

#import "CTDCoreGraphicsUtils.h"


static CGFloat const kToolbarCellWidth = 100; // TODO: Query cells for their width
//static CGFloat const kToolbarCellHeight = 50;
static CGFloat const kToolbarCellDividerThickness = 5;
static CGFloat const kToolbarFrameThickness = 4;



@implementation CTDUIKitToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer* rootLayer = self.layer;
        rootLayer.backgroundColor = [[UIColor grayColor] CGColor];
        [self setNeedsLayout];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    CGFloat toolbarHeight = self.bounds.size.height;

    CGPoint cellPosition = (CGPoint){ kToolbarFrameThickness,
                                      kToolbarFrameThickness };

    // TODO: Query the cell for its width and use that. (Height will either
    //   be restricted to that of the toolbar, or we could have the toolbar
    //   autoexpand to fit the tallest cell.)
    CGSize cellSize = (CGSize){ kToolbarCellWidth,
                                toolbarHeight - (kToolbarFrameThickness * 2)};

    for (UIView* cellView in self.subviews) {
        cellView.frame = ctdCGRectMake(cellPosition, cellSize);
        cellPosition.x += kToolbarCellWidth + kToolbarCellDividerThickness;
    }

    CGFloat toolbarWidth = cellPosition.x
                         - kToolbarCellDividerThickness
                         + kToolbarFrameThickness;
    self.bounds = CGRectMake(0, 0, toolbarWidth, toolbarHeight);
    [self setNeedsDisplay];
}

@end
