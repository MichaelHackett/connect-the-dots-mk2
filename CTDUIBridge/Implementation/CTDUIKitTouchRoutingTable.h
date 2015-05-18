// CTDUIKitTouchRoutingTable:
//     Maps UITouch objects to their corresponding CTDTouchTrackers, where one
//     has been assigned.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTouchTracker;


@interface CTDUIKitTouchRoutingTable : NSObject

- (void)setTracker:(id<CTDTouchTracker>)touchTracker forTouch:(UITouch*)touch;
- (id<CTDTouchTracker>)trackerForTouch:(UITouch*)touch;

@end
