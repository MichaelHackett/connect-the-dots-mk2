// CTDSelectOnTapInteraction:
//     Selects the element under the touch when the touch is released while
//     over the element.
//
//     Uses the given CTDTouchToElementMapper to map the touch position to UI
//     elements, by ID. If there is a potential overlap in targets, the touch
//     mapper is responsible for deciding which element "wins" and is chosen
//     for selection.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;
@protocol CTDTouchToElementMapper;
@protocol CTDSelectionEditor;



@interface CTDSelectOnTapInteraction : NSObject <CTDTouchTracker>

- (instancetype)initWithSelectionEditor:(id<CTDSelectionEditor>)selectionEditor
                            touchMapper:(id<CTDTouchToElementMapper>)touchMapper
                   initialTouchPosition:(CTDPoint*)initialPosition;
CTD_NO_DEFAULT_INIT

@end
