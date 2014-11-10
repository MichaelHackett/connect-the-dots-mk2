// CTDRecordingTouchTracker:
//     Hand-rolled test spy to stand in for a CTDTouchTracker.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;



@interface CTDRecordingTouchTracker : NSObject <CTDTouchTracker>

@property (copy, readonly, nonatomic) CTDPoint* lastTouchPosition;
@property (copy, readonly, nonatomic) NSArray* messagesReceived;

@end
