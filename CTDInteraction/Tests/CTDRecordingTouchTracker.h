// CTDRecordingTouchTracker:
//     Hand-rolled test spy to stand in for a CTDTouchTracker.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIBridge/ExtensionPoints/CTDTouchResponder.h"
#import "CTDTestHelpers/CTDTestSpy.h"

@class CTDPoint;



@interface CTDRecordingTouchTracker : CTDTestSpy <CTDTouchTracker>

@property (copy, readonly, nonatomic) CTDPoint* lastTouchPosition;

- (NSArray*)touchTrackingMesssagesReceived;

@end
