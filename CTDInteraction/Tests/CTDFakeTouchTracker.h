// CTDFakeTouchTracker:
//     Hand-rolled test spy to stand in for a CTDTouchTracker.
//
//     As opposed to a CTDRecordingTouchTracker, it does not record and present
//     all the individual messages it receives, but rather only exposes the
//     current state as a result of acting on those messages. It also raises
//     exceptions if sent messages that are inappropriate for the tracker's
//     current state.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;


typedef NSString* CTDFakeTouchTrackerState;

FOUNDATION_EXPORT CTDFakeTouchTrackerState const CTDTouchTrackerStateActive;
FOUNDATION_EXPORT CTDFakeTouchTrackerState const CTDTouchTrackerStateEnded;
FOUNDATION_EXPORT CTDFakeTouchTrackerState const CTDTouchTrackerStateCancelled;




@interface CTDFakeTouchTracker : NSObject <CTDTouchTracker>

@property (copy, readonly, nonatomic) CTDPoint* lastTouchPosition;
@property (assign, readonly, nonatomic) CTDFakeTouchTrackerState state;

- (void)reset;

@end
