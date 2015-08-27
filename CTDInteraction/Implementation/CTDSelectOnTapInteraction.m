// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDSelectOnTapInteraction.h"

#import "Ports/CTDSelectionEditor.h"
#import "Ports/CTDTouchMappers.h"

#import "CTDUtility/CTDPoint.h"




//
// Internal helper to avoid repeating touch mapping logic with initial position
// and for when the touch position changes.
//
@interface CTDSelectOnTapInteraction_TouchMapper : NSObject

@property (copy, readonly, nonatomic) id selectedElementId;


- (instancetype)initWithTouchMapper:(id<CTDTouchToElementMapper>)touchMapper
                    selectionEditor:(id<CTDSelectionEditor>)selectionEditor;
CTD_NO_DEFAULT_INIT

- (void)selectElementAtTouchPosition:(CTDPoint*)touchPosition;

@end


@implementation CTDSelectOnTapInteraction_TouchMapper
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
        [_selectionEditor selectElementWithId:hitElementId];
        _selectedElementId = [hitElementId copy];
    }
    else
    {
        [_selectionEditor clearSelection];
        _selectedElementId = nil;
    }
}

@end




@implementation CTDSelectOnTapInteraction
{
    CTDSelectOnTapInteraction_TouchMapper* _touchMapper;
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
        _touchMapper = [[CTDSelectOnTapInteraction_TouchMapper alloc]
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
    if (_touchMapper.selectedElementId)
    {
        [_selectionEditor commitSelection];
    }
    else
    {
        [_selectionEditor cancelSelection];
    }
}

- (void)touchWasCancelled
{
    [_selectionEditor cancelSelection];
}

@end
