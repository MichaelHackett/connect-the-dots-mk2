// CTDSelectionEditor:
//     Editing interface for an interaction that selects elements.
//
// Copyright 2015 Michael Hackett. All rights reserved.


@protocol CTDSelectionEditor <NSObject>

- (void)highlightElementWithId:(id)elementId;
- (void)clearHighlighting;
- (void)selectElementWithId:(id)elementId;
- (void)clearSelection;

@end
