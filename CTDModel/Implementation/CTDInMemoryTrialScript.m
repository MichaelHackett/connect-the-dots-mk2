// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDInMemoryTrialScript.h"


@implementation CTDInMemoryTrialScript
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



#pragma mark CTDTrialScript protocol


- (NSArray*)dotPairs {
    return _dotPairs;
}

@end
