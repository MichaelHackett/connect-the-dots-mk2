// CTDSelectionEditor:
//     Editing interface for an interaction that selects elements.
//
//     One of `commitSelection` or `cancelSelection` must be called before
//     releasing the Editor, otherwise the implementation may throw an
//     exception. (If it chooses not to, it must treat any unterminated
//     Editor transaction as if cancelled.)
//
// Copyright 2015 Michael Hackett. All rights reserved.


@protocol CTDSelectionEditor <NSObject>

- (void)selectElementWithId:(id)elementId;
- (void)clearSelection;

- (void)commitSelection;
- (void)cancelSelection;

@end
