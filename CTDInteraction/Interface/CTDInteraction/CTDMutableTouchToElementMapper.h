// CTDMutableTouchToElementMapper:
//     Some touch-to-element mapper whose elements can changed dynamically at
//     run-time. The disambiguation algorithm (when two elements overlap) is
//     provided by the concrete implementations of this protocol.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "./Ports/CTDTouchMappers.h"
@protocol CTDTouchable;



@protocol CTDMutableTouchToElementMapper <CTDTouchToElementMapper>

- (void)mapTouchable:(id<CTDTouchable>)touchableElement
          toActuator:(id)actuator;
- (void)unmapTouchable:(id<CTDTouchable>)touchableElement;

@end
