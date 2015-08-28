// CTDColorCellRenderer:
//     Renderer for a color selection UI element.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "./CTDSelectionRenderer.h"


// Color cell element IDs start at this value and are sequential.
#define CTDColorCellIdMin ((NSUInteger)1)

// Note: I think the above really belongs in CTDConnectScene.h, but the
// Connection Activity doesn't "know" about that, so it has to go here.
// Revisit this later.]



@protocol CTDColorCellRenderer <CTDSelectionRenderer>

- (void)showHighlightIndicator;
- (void)hideHighlightIndicator;

@end
