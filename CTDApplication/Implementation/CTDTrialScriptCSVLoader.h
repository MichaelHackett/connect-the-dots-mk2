// CTDTrialScriptCSVLoader:
//     Reads trial script data in a CSV-style format.
//
// Each line of the file contains a sequence of 5 elements (separated by
// commas), representing a trial step:
// - a integer color/pattern index for the pair of dots (1-3)
// - the x-coordinate of the first dot, as a floating point number 0.0..1.0
// - the y-coordinate of the first dot
// - the x-coordinate of the second dot
// - the y-coordinate of the second dot
//
// When processing this data, the reader read as many lines as it needs to
// fill a sequence (as set in the application's configuration), then start the
// next sequence from the following line. If it reaches the end of the file
// before filling the nunber of sequences requested, it will return to the
// beginning of the file and continue reading from there. (Ideally, though,
// there should be enough data supplied to fulfill the desired number of
// sequences, erring on the side of too many pairs than too few.
//
// Copyright (c) 2015 Michael Hackett. All rights reserved.

#import <Foundation/Foundation.h>

@interface CTDTrialScriptCSVLoader : NSObject

+ (NSArray*)sequencesFromFileAtPath:(NSString*)path
                      sequenceCount:(NSUInteger)sequenceCount
                     sequenceLength:(NSUInteger)sequenceLength // steps per sequence
                              error:(NSError *__autoreleasing *)error;

@end
