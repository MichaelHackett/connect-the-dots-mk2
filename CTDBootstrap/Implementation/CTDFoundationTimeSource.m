// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDFoundationTimeSource.h"

#import <mach/mach_time.h>



@implementation CTDFoundationTimeSource

- (NSDate*)wallTime
{
    return [NSDate date];
}

- (double)systemTime
{
    static mach_timebase_info_data_t s_timebase_info;
    if (s_timebase_info.denom == 0)
    {
        (void) mach_timebase_info(&s_timebase_info);
    }

    uint64_t nanosecs = (mach_absolute_time() * s_timebase_info.numer) / s_timebase_info.denom;
    return (double)nanosecs / NSEC_PER_SEC;
}

@end
