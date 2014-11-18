// CTDListOrderTouchMapper:
//     Performs a simple sequential pass through a list of CTDTouchable
//     elements and returns the first that passes the hit test.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchMapper.h"

@protocol CTDTouchable;



@interface CTDListOrderTouchMapper : NSObject <CTDTouchMapper>

- (void)mapTouchable:(id<CTDTouchable>)touchableElement
          toActuator:(id)actuator;
- (void)unmapTouchable:(id<CTDTouchable>)touchableElement;

@end
