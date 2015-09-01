// CTDFoundationTimeSource:
//     Time source that uses NSDate's default initializer to obtain the current
//     "wall clock" time and mach_absolute_time() for "system time".
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication/Ports/CTDTimeSource.h"


@interface CTDFoundationTimeSource : NSObject <CTDTimeSource>
@end
