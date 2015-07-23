// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDColorCellGroup.h"

#import "CTDSelectable.h"
#import "Ports/CTDSelectionRenderer.h"




@protocol CTDColorCellGroupSelectionFilter <NSObject>
- (void)selectCellWithColor:(CTDDotColor)color;
- (void)deselectIfSelectedCellWithColor:(CTDDotColor)color;
@end



// CellProxy:
//     Provides the external interface to cells within a cell group. Filters
//     all selection change requests through the group.

@interface CTDColorCellGroup_CellProxy : NSObject <CTDSelectable>
- (instancetype)initWithCellColor:(CTDDotColor)cellColor
             groupSelectionFilter:
                 (id<CTDColorCellGroupSelectionFilter>)groupSelectionFilter;
@end

@implementation CTDColorCellGroup_CellProxy
{
    CTDDotColor _cellColor;
    id<CTDColorCellGroupSelectionFilter> _groupSelectionFilter;
}

- (instancetype)initWithCellColor:(CTDDotColor)cellColor
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

- (instancetype)initWithDefaultColor:(CTDDotColor)defaultColor
                   selectedColorSink:(id<CTDDotColorSink>)selectedColorSink;

- (void)addSelectionRenderer:(id<CTDSelectionRenderer>)cellSelectionRenderer
            forCellWithColor:(CTDDotColor)cellColor;

@end

@implementation CTDColorCellGroup_MutexFilter
{
    CTDDotColor _defaultColor;
    id<CTDDotColorSink> _selectedColorSink;
    CTDDotColor _selectedColor;
    NSMutableDictionary* _colorToCellRendererMap;
}

- (instancetype)initWithDefaultColor:(CTDDotColor)defaultColor
                   selectedColorSink:(id<CTDDotColorSink>)selectedColorSink;
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

- (void)addSelectionRenderer:(id<CTDSelectionRenderer>)cellSelectionRenderer
            forCellWithColor:(CTDDotColor)cellColor
{
    [_colorToCellRendererMap setObject:cellSelectionRenderer forKey:@(cellColor)];
}

- (void)selectCellWithColor:(CTDDotColor)color
{
    // TODO: filter requests that don't change the state of the element
    // (doesn't change defined behaviour, so no tests required?)

    // Hide previous selection, if any.
    id <CTDSelectionRenderer> deselectedCellRenderer =
        [_colorToCellRendererMap objectForKey:@(_selectedColor)];
    [deselectedCellRenderer hideSelectionIndicator];

    // Update state and notify selection listener.
    _selectedColor = color;
    [_selectedColorSink colorChangedTo:color];

    // Show new selection.
    id <CTDSelectionRenderer> selectedCellRenderer =
        [_colorToCellRendererMap objectForKey:@(color)];
    [selectedCellRenderer showSelectionIndicator];
}

- (void)deselectIfSelectedCellWithColor:(CTDDotColor)color
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
//    NSMutableArray* _cells; // not required until cell removal needs to be supported
}

- (instancetype)initWithDefaultColor:(CTDDotColor)defaultColor
                   selectedColorSink:(id<CTDDotColorSink>)selectedColorSink
{
    self = [super init];
    if (self) {
        _mutex = [[CTDColorCellGroup_MutexFilter alloc]
                  initWithDefaultColor:defaultColor
                     selectedColorSink:selectedColorSink];
//        _cells = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id<CTDSelectable>)addCellForColor:(CTDDotColor)cellColor
                        withRenderer:(id<CTDSelectionRenderer>)cellSelectionRenderer;
{
    [cellSelectionRenderer hideSelectionIndicator]; // sync renderer to new cell's state
    [_mutex addSelectionRenderer:cellSelectionRenderer forCellWithColor:cellColor];
    CTDColorCellGroup_CellProxy* cellProxy = [[CTDColorCellGroup_CellProxy alloc]
                                              initWithCellColor:cellColor
                                              groupSelectionFilter:_mutex];
//    [_cells addObject:cellProxy];
    return cellProxy;
}

@end
