// CTDDelegatingTouchTracker:
//     A CTDTouchTracker that forwards all protocol messages to another
//     CTDTouchTracker, which can be changed on the fly. This allows the
//     decision about how to handle a touch to be deferred until further
//     action makes the user's intention clearer.
//
//     This is useful because Touch Trackers can only be registered when a
//     touch responder is first notified that a new touch has begun. The
//     delegating tracker can be registered and the initial delegate can later
//     change the delegate to another tracker, if conditions warrant.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"


@interface CTDDelegatingTouchTracker : NSObject <CTDTouchTracker>

// Designated initializer
- (instancetype)initWithInitialDelegate:(id<CTDTouchTracker>)delegateTracker;
// Initialize without an initial delegate
- (instancetype)init;

- (void)changeDelegateTo:(id<CTDTouchTracker>)newDelegate;

@end
