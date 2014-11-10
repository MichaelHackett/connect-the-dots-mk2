// CTDSelectOnTouchInteraction:
//     Selects the element under the touch being tracked while the touch is
//     active.
//
//     Uses the given CTDTouchMapper to map the touch position to UI elements;
//     these element should conform to the CTDSelectionRenderer protocol in
//     order for the tracker to trigger selection and deselection. If there
//     is a potential overlap in targets, the touch mapper is responsible for
//     deciding which element "wins" and is chosen for selection.
//
// TODO: This interaction should operate on a model element, not directly
//   with the renderer.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;
@protocol CTDTouchMapper;



@interface CTDSelectOnTouchInteraction : NSObject <CTDTouchTracker>

- (instancetype)initWithTouchMapper:(id<CTDTouchMapper>)targetTouchMapper
                initialTouchPosition:(CTDPoint*)initialPosition;
CTD_NO_DEFAULT_INIT

@end
