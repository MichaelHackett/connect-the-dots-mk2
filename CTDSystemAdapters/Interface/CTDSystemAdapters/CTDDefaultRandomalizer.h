// CTDDefaultRandomalizer:
//     Uses stdlib's random function for pseudo-random number generation. May
//     also use arc4random in some cases, but where a pseudo-random stream
//     using a given seed is required, random/srandom must be used, as
//     arc4random does not support this.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication/Ports/CTDRandomalizer.h"


@interface CTDDefaultRandomalizer : NSObject <CTDRandomalizer>
@end
