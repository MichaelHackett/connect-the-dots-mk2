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

@property (copy, readonly, nonatomic) id highlightedElementId;


- (instancetype)initWithTouchMapper:(id<CTDTouchToElementMapper>)touchMapper
                    selectionEditor:(id<CTDSelectionEditor>)selectionEditor;
CTD_NO_DEFAULT_INIT

- (void)highlightElementAtTouchPosition:(CTDPoint*)touchPosition;

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
        _highlightedElementId = nil;
    }
    return self;
}

- (void)highlightElementAtTouchPosition:(CTDPoint*)touchPosition
{
    id hitElementId = [_touchMapper idOfElementAtTouchLocation:touchPosition];
    if (hitElementId)
    {
        [_selectionEditor highlightElementWithId:hitElementId];
        _highlightedElementId = [hitElementId copy];
    }
    else if (_highlightedElementId)
    {
        [_selectionEditor clearHighlighting];
        _highlightedElementId = nil;
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

        [_touchMapper highlightElementAtTouchPosition:initialPosition];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    [_touchMapper highlightElementAtTouchPosition:newPosition];
}

- (void)touchDidEnd
{
    id highlightedElementId = _touchMapper.highlightedElementId;
    if (highlightedElementId)
    {
        [_selectionEditor selectElementWithId:highlightedElementId];
        [_selectionEditor clearHighlighting];
    }
}

- (void)touchWasCancelled
{
    [_selectionEditor clearHighlighting];
}

@end
