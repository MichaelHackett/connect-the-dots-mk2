// CTDRecordingTouchTracker:
//     Hand-rolled test spy to stand in for a CTDTouchTracker.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"
#import "CTDTestHelpers/CTDTestSpy.h"

@class CTDMethodSelector;
@class CTDPoint;



@interface CTDRecordingTouchTracker : CTDTestSpy <CTDTouchTracker>

@property (copy, readonly, nonatomic) CTDPoint* lastTouchPosition;
@property (copy, readonly, nonatomic) CTDMethodSelector* lastTrackerMessage; // nil if no messages received

- (NSUInteger)countOfTrackerMessagesReceived; // # of CTDTouchTracker messages

@end
