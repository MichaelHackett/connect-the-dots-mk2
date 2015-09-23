// CTDRandomalizer:
//     A source of random (or pseudo-random) data, in various forms.
//
// (Defining the interface to be high level allows the implementation to be
// tailored to the details of the PRNG used, but could result in too much
// duplication between implementations. Granted, I expect there to be only one
// _real_ implementation (plus test doubles), so perhaps this is fine in this
// case.)
//
// Copyright 2015 Michael Hackett. All rights reserved.


@protocol CTDRandomalizer <NSObject>

- (NSArray*)randomizeList:(NSArray*)originalList
                     seed:(unsigned long)seed;

@end
