// CTDSelectOnTouchInteraction:
//     Selects the element under the touch being tracked while the touch is
//     active.
//
//     Uses the given CTDTouchToElementMapper to map the touch position to UI
//     elements; these elements should conform to the CTDSelectable protocol in
//     order for the tracker to trigger selection and deselection. If there is
//     a potential overlap in targets, the touch mapper is responsible for
//     deciding which element "wins" and is chosen for selection.
//
// TODO: This interaction should operate on a presentation element, not directly
//   with the renderer.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;
@protocol CTDTouchToElementMapper;



@interface CTDSelectOnTouchInteraction : NSObject <CTDTouchTracker>

- (instancetype)initWithTouchMapper:(id<CTDTouchToElementMapper>)touchMapper
                initialTouchPosition:(CTDPoint*)initialPosition;
CTD_NO_DEFAULT_INIT

@end
