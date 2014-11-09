// CTDTouchTrackingGroup:
//     A CTDTouchTracker that redistributes all tracking messages to the
//     members of the group (also CTDTouchTrackers). This is a simple way to
//     combine multiple simple touch handlers to simultaneously process touch
//     information. If the handlers need to modify their behaviour based on
//     what other handlers are doing, they will need an outside channel for
//     communicating directly with each other.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"



@interface CTDTouchTrackingGroup : NSObject <CTDTouchTracker>

- (void)addTracker:(id<CTDTouchTracker>)touchTracker;
- (void)removeTracker:(id<CTDTouchTracker>)touchTracker;

@end
