// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDColorCellGroup.h"

#import "CTDColorCellRenderer.h"
#import "CTDSelectable.h"




@protocol CTDColorCellGroupSelectionFilter <NSObject>
- (void)selectCellWithColor:(CTDTargetColor)color;
- (void)deselectIfSelectedCellWithColor:(CTDTargetColor)color;
@end



// CellProxy:
//     Provides the external interface to cells within a cell group. Filters
//     all selection change requests through the group.

@interface CTDColorCellGroup_CellProxy : NSObject <CTDSelectable>
- (instancetype)initWithCellColor:(CTDTargetColor)cellColor
             groupSelectionFilter:
                 (id<CTDColorCellGroupSelectionFilter>)groupSelectionFilter;
@end

@implementation CTDColorCellGroup_CellProxy
{
    CTDTargetColor _cellColor;
    id<CTDColorCellGroupSelectionFilter> _groupSelectionFilter;
}

- (instancetype)initWithCellColor:(CTDTargetColor)cellColor
             groupSelectionFilter:
                 (id<CTDColorCellGroupSelectionFilter>)groupSelectionFilter
{
    self = [super init];
    if (self) {
        _cellColor = cellColor;
        _groupSelectionFilter = groupSelectionFilter;
    }
    return self;
}

- (void)select
{
    [_groupSelectionFilter selectCellWithColor:_cellColor];
}

- (void)deselect
{
    [_groupSelectionFilter deselectIfSelectedCellWithColor:_cellColor];
}

@end





// MutexFilter:
//     Ensures that only one cell is selected at a time, updates the cell
//     renderers as required, and notifies the selected-color listener about
//     any changes.

@interface CTDColorCellGroup_MutexFilter : NSObject <CTDColorCellGroupSelectionFilter>

- (instancetype)initWithDefaultColor:(CTDTargetColor)defaultColor
                   selectedColorSink:(id<CTDTargetColorSink>)selectedColorSink;

- (void)addRenderer:(id<CTDColorCellRenderer>)cellRenderer
   forCellWithColor:(CTDTargetColor)cellColor;

@end

@implementation CTDColorCellGroup_MutexFilter
{
    CTDTargetColor _defaultColor;
    id<CTDTargetColorSink> _selectedColorSink;
    CTDTargetColor _selectedColor;
    NSMutableDictionary* _colorToCellRendererMap;
}

- (instancetype)initWithDefaultColor:(CTDTargetColor)defaultColor
                   selectedColorSink:(id<CTDTargetColorSink>)selectedColorSink;
{
    self = [super init];
    if (self) {
        _defaultColor = defaultColor;
        _selectedColorSink = selectedColorSink;
        _selectedColor = defaultColor;
        _colorToCellRendererMap = [[NSMutableDictionary alloc] init];

        [selectedColorSink colorChangedTo:_selectedColor];
    }
    return self;
}

- (void)addRenderer:(id<CTDColorCellRenderer>)cellRenderer
   forCellWithColor:(CTDTargetColor)cellColor
{
    [_colorToCellRendererMap setObject:cellRenderer forKey:@(cellColor)];
}

- (void)selectCellWithColor:(CTDTargetColor)color
{
    // TODO: filter requests that don't change the state of the element
    // (doesn't change defined behaviour, so no tests required?)

    // Hide previous selection, if any.
    id <CTDColorCellRenderer> deselectedCellRenderer =
        [_colorToCellRendererMap objectForKey:@(_selectedColor)];
    [deselectedCellRenderer hideSelectionIndicator];

    // Update state and notify selection listener.
    _selectedColor = color;
    [_selectedColorSink colorChangedTo:color];

    // Show new selection.
    id <CTDColorCellRenderer> selectedCellRenderer =
        [_colorToCellRendererMap objectForKey:@(color)];
    [selectedCellRenderer showSelectionIndicator];
}

- (void)deselectIfSelectedCellWithColor:(CTDTargetColor)color
{
    // Only deselect cell if it was currently selected.
    if (color == _selectedColor) {
        [self selectCellWithColor:_defaultColor];
    }
}

@end





//
// Main class
//


@implementation CTDColorCellGroup
{
    CTDColorCellGroup_MutexFilter* _mutex;
    NSMutableArray* _cells;
}

- (instancetype)initWithDefaultColor:(CTDTargetColor)defaultColor
                   selectedColorSink:(id<CTDTargetColorSink>)selectedColorSink
{
    self = [super init];
    if (self) {
        _mutex = [[CTDColorCellGroup_MutexFilter alloc]
                  initWithDefaultColor:defaultColor
                     selectedColorSink:selectedColorSink];
        _cells = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id<CTDSelectable>)addCellForColor:(CTDTargetColor)cellColor
                        withRenderer:(id<CTDColorCellRenderer>)cellRenderer;
{
    [_mutex addRenderer:cellRenderer forCellWithColor:cellColor];
    CTDColorCellGroup_CellProxy* cellProxy = [[CTDColorCellGroup_CellProxy alloc]
                                              initWithCellColor:cellColor
                                              groupSelectionFilter:_mutex];
    [_cells addObject:cellProxy];
    return cellProxy;
}

@end
