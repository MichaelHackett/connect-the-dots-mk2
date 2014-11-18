// CTDColorCellGroup:
//     Manages a set of color selection cells to ensure that only one can be
//     selected at any time and to provide easy access to the current selection.
//
// Implementation:
// When a cell is added to the set, a new CTDSelectable proxy is returned to
// act as the control interface to the cell, in place of the original cell
// itself. Attempts to change the selection state of the cell should only be
// done through this proxy, so that the CTDColorCellGroup can act as a filter
// for such requests, cascading changes to other cells in the group as
// necessary.
//
// In the current implementation, it is not necessary to retain the
// CTDColorCellGroup after adding all of the cells; as long as the returned
// cell proxies are retained, the mutex control will be retained.
//
// TODO: Extract a base MutexSelectionGroup class that implements the mutex,
// having the ColorButtonSet extend this and convert the selection identifier
// into a CTDTargetColor.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDModel/CTDTargetColor.h"

@protocol CTDColorCellRenderer;
@protocol CTDSelectable;




@interface CTDColorCellGroup : NSObject

- (instancetype)initWithDefaultColor:(CTDTargetColor)defaultColor
                   selectedColorSink:(id<CTDTargetColorSink>)selectedColorSink;
CTD_NO_DEFAULT_INIT

- (id<CTDSelectable>)addCellForColor:(CTDTargetColor)cellColor
                        withRenderer:(id<CTDColorCellRenderer>)cellRenderer;

@end
