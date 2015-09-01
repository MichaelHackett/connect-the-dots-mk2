// CTDTimeSource:
//     Provides the current time.
//
// Copyright 2015 Michael Hackett. All rights reserved.


@protocol CTDTimeSource <NSObject>

// "Wall time" is the type you would get from a clock on the wall --- that is,
// the user-facing time, in the local time zone. It may change suddenly at any
// time, due to the user or the system making an adjustment or changing the
// time zone.
- (NSDate*)wallTime;

// "System time" is a guaranteed-ascending time value that is independent of
// any clock or time zone changes. It _may_ stop when the system is inactive,
// so it cannot be relied upon for long-running timers, but may be useful when
// used to time a user action, or when absolute accuracy isn't required.
- (double)systemTime; // in seconds, with at least millisecond precision

@end
