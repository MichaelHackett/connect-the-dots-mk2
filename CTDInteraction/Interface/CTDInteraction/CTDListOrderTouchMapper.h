// CTDListOrderTouchMapper:
//     Performs a simple sequential pass through a list of CTDTouchable
//     elements and returns the first that passes the hit test.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "ExtensionPoints/CTDTouchMappers.h"

@protocol CTDTouchable;



@interface CTDListOrderTouchMapper : NSObject <CTDTouchToElementMapper>

- (void)mapTouchable:(id<CTDTouchable>)touchableElement
          toActuator:(id)actuator;
- (void)unmapTouchable:(id<CTDTouchable>)touchableElement;

@end
