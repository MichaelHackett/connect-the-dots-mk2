// CTDStubTimeSource:
//     A CTDTimeSource stub that allows the injection of an arbitrary sequence
//     of time values into the object using the time source.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "Ports/CTDTimeSource.h"


@interface CTDStubTimeSource : NSObject <CTDTimeSource>

@property (assign, nonatomic) double systemTime;

@end
