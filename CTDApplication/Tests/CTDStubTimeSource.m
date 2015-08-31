// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDStubTimeSource.h"



@implementation CTDStubTimeSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _systemTime = 0;
    }
    return self;
}

- (NSDate*)wallTime
{
    // Not implemented
    [NSException raise:NSInternalInconsistencyException
                format:@"wall time requested unexpectedly"];
    return nil;
}

@end
