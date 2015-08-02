// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDInMemoryTrial.h"


@implementation CTDInMemoryTrial
{
    NSArray* _dotPairs;
}


#pragma mark Object lifecycle


- (id)init CTD_BLOCK_PARENT_METHOD

- (instancetype)initWithDotPairs:(NSArray*)dotPairs {
    self = [super init];
    if (self) {
        _dotPairs = [dotPairs copy];
    }
    return self;
}



#pragma mark CTDTrial protocol


- (NSArray*)dotPairs {
    return _dotPairs;
}

@end
