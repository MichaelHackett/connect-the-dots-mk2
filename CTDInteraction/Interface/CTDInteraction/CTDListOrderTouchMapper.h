// CTDListOrderTouchMapper:
//     Performs a simple sequential pass through a list of CTDTouchable
//     elements and returns the first that passes the hit test.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "./CTDMutableTouchToElementMapper.h"
@protocol CTDTouchable;



@interface CTDListOrderTouchMapper : NSObject <CTDMutableTouchToElementMapper>

@end
