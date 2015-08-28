// CTDTrial:
//     Given a sequence of dot pairs, a trial plays the sequence in order and
//     records the connection attempts made, to the level of detail required
//     for data collection.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTrial <NSObject>

- (NSArray*)dotPairs;

@end
