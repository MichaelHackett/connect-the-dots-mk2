// CTDSelectOnTapInteraction:
//     Selects the element under the touch when the touch is released while
//     over the element.
//
//     Uses the given CTDTouchMapper to map the touch position to UI elements;
//     these elements should conform to the CTDSelectable protocol in order
//     for the tracker to trigger selection and deselection. If there is a
//     potential overlap in targets, the touch mapper is responsible for
//     deciding which element "wins" and is chosen for selection.
//
// TODO: This interaction should operate on a model element, not directly
//   with the renderer.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIBridge/ExtensionPoints/CTDTouchResponder.h"

@class CTDPoint;
@protocol CTDTouchMapper;



@interface CTDSelectOnTapInteraction : NSObject <CTDTouchTracker>

- (instancetype)initWithTouchMapper:(id<CTDTouchMapper>)touchMapper
                initialTouchPosition:(CTDPoint*)initialPosition;
CTD_NO_DEFAULT_INIT

@end
