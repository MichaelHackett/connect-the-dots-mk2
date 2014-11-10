// CTDUIKitToolbar:
//     A container for the special buttons used in the CTD application.
//
// Copyright 2013-4 Michael Hackett. All rights reserved.


// Q: Where to put the CTDTouchable interface? It would seem preferable to
// have the toolbar map touches to subelements, so it can be done in one
// place, but it would need to be a TouchMapper, not a Touchable. Maybe the
// toolbar can create its own cell objects when given the content view and
// an action block... Then, the cells can be Touchables, the touch mapping
// can be done at the presentation level (where it can be more easily tested),
// but the touch region mapping is kept in the Toolbar module (in a private
// helper class for the cell objects).

#import "CTDPresentation/CTDSelectionRenderer.h"



@protocol CTDUIKitToolbarCell <CTDSelectionRenderer>
- (UIView*)toolbarCellContentView;
@end


@interface CTDUIKitToolbar : UIView

- (void)addCell:(id<CTDUIKitToolbarCell>)cell;

@end
