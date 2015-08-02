// CTDInMemoryTrial:
//     Basic in-memory implementation of a CTDTrial.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTrial.h"


@interface CTDInMemoryTrial : NSObject <CTDTrial>

- (instancetype)initWithDotPairs:(NSArray*)dotPairs;  // array of CTDDotPairs

CTD_NO_DEFAULT_INIT

@end
