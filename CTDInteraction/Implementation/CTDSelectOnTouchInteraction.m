// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDSelectOnTouchInteraction.h"

#import "Ports/CTDSelectionEditor.h"
#import "Ports/CTDTouchMappers.h"

#import "CTDUtility/CTDPoint.h"



//
// Internal helper to avoid repeating touch mapping logic with initial position
// and for when the touch position changes.
//
@interface CTDSelectOnTouchInteraction_TouchMapper : NSObject

@property (copy, readonly, nonatomic) id selectedElementId;


- (instancetype)initWithTouchMapper:(id<CTDTouchToElementMapper>)touchMapper
                    selectionEditor:(id<CTDSelectionEditor>)selectionEditor;
CTD_NO_DEFAULT_INIT

- (void)selectElementAtTouchPosition:(CTDPoint*)touchPosition;

@end


@implementation CTDSelectOnTouchInteraction_TouchMapper
{
    id<CTDTouchToElementMapper> _touchMapper;
    id<CTDSelectionEditor> _selectionEditor;
}

- (instancetype)initWithTouchMapper:(id<CTDTouchToElementMapper>)touchMapper
                    selectionEditor:(id<CTDSelectionEditor>)selectionEditor
{
    self = [super init];
    if (self)
    {
        _touchMapper = touchMapper;
        _selectionEditor = selectionEditor;
        _selectedElementId = nil;
    }
    return self;
}

- (void)selectElementAtTouchPosition:(CTDPoint*)touchPosition
{
    id hitElementId = [_touchMapper idOfElementAtTouchLocation:touchPosition];
    if (hitElementId)
    {
        [_selectionEditor highlightElementWithId:hitElementId];
        [_selectionEditor selectElementWithId:hitElementId];
        _selectedElementId = [hitElementId copy];
    }
    else if (_selectedElementId)
    {
        [_selectionEditor clearHighlighting];
        [_selectionEditor clearSelection];
        _selectedElementId = nil;
    }
}

@end




@implementation CTDSelectOnTouchInteraction
{
    CTDSelectOnTouchInteraction_TouchMapper* _touchMapper;
    id<CTDSelectionEditor> _selectionEditor;
}



#pragma mark Initialization


- (instancetype)initWithSelectionEditor:(id<CTDSelectionEditor>)selectionEditor
                            touchMapper:(id<CTDTouchToElementMapper>)touchMapper
                   initialTouchPosition:(CTDPoint*)initialPosition
{
    self = [super init];
    if (self)
    {
        _touchMapper = [[CTDSelectOnTouchInteraction_TouchMapper alloc]
                        initWithTouchMapper:touchMapper
                            selectionEditor:selectionEditor];
        _selectionEditor = selectionEditor;

        [_touchMapper selectElementAtTouchPosition:initialPosition];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    [_touchMapper selectElementAtTouchPosition:newPosition];
}

- (void)touchDidEnd
{
    [_selectionEditor clearHighlighting];
    [_selectionEditor clearSelection];
}

- (void)touchWasCancelled
{
    [self touchDidEnd];
}

@end
