// CTDRunLoopTimer:
//     A wrapper for timer functionality. It works similarly to NSTimer,
//     and is similarly triggered from the current run loop, but uses blocks
//     for the triggered code, and may use a different underlying mechanism.
//
//     These timers must be created from the main UI thread and will execute
//     their blocks on the same thread.
//
// NOTE: Actually, I'm assuming that NSTimer executes its callbacks on the
//       thread to which the runloop belongs, but I've not found anything
//       quite definitive that confirms this.
//
//       Also, if there becomes a need to create these objects from a
//       background thread, the class could be modified to _always_ use the
//       main run loop (or add an alternative initializer that supports this),
//       and take care of getting the main run loop and scheduling the task
//       there.
//
// Copyright 2015 Michael Hackett. All rights reserved.


@interface CTDRunLoopTimer : NSObject

- (instancetype)initWithDuration:(NSTimeInterval)timeInterval
                    onExpiration:(void (^)(void))timerExpirationBlock;
CTD_NO_DEFAULT_INIT


- (void)invalidate;

@end
