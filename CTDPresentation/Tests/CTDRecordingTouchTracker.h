// CTDRecordingTouchTracker:
//     Hand-rolled test spy to stand in for a CTDTouchTracker.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDMethodSelector;
@class CTDPoint;



@interface CTDRecordingTouchTracker : NSObject <CTDTouchTracker>

@property (copy, readonly, nonatomic) CTDPoint* lastTouchPosition;

- (void)reset;
- (CTDMethodSelector*)lastMessage; // nil if no messages received
- (BOOL)hasReceivedMessage:(SEL)selector;
- (NSUInteger)countOfTrackerMessagesReceived; // # of CTDTouchTracker messages

@end
