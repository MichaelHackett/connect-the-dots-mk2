// CTDInMemoryTrialScript:
//     Basic in-memory implementation of a CTDTrialScript.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTrialScript.h"


@interface CTDInMemoryTrialScript : NSObject <CTDTrialScript>

- (instancetype)initWithDotPairs:(NSArray*)dotPairs;  // array of CTDDotPairs

CTD_NO_DEFAULT_INIT

@end
