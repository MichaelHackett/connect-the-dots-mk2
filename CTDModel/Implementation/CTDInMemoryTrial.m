// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDInMemoryTrial.h"


@implementation CTDInMemoryTrial
{
    NSArray* _dotList;
}


#pragma mark Object lifecycle


- (id)init CTD_BLOCK_PARENT_METHOD

- (instancetype)initWithDots:(NSArray*)dots {
    self = [super init];
    if (self) {
        _dotList = [dots copy];
    }
    return self;
}



#pragma mark CTDTrial protocol


- (NSArray*)dotList {
    return _dotList;
}

@end
