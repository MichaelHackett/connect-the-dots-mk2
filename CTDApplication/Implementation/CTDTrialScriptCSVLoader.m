// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTrialScriptCSVLoader.h"

#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDInMemoryTrialScript.h"
#import "CTDUtility/CTDPoint.h"
//#import <stdio.h>


//static NSUInteger const lineReaderChunkSize = 1024;


@implementation CTDTrialScriptCSVLoader

+ (NSArray*)sequencesFromFileAtPath:(NSString*)path
                      sequenceCount:(NSUInteger)sequenceCount
                     sequenceLength:(NSUInteger)sequenceLength // steps per sequence
                              error:(NSError *__autoreleasing *)error
{
    NSAssert(sequenceCount >= 1,
             @"sequenceCount must be at least 1 (was %lu)", (unsigned long)sequenceCount);
    NSAssert(sequenceLength >= 1,
             @"sequenceLength must be at least 1 (was %lu)", (unsigned long)sequenceLength);

    NSString* contents = [NSString stringWithContentsOfFile:path
                                                   encoding:NSASCIIStringEncoding
                                                   error:error];
    if (!contents) { return nil; }

    NSMutableArray* sequences = [NSMutableArray array];
    NSMutableArray* dotPairs = [NSMutableArray array]; // representing the steps of a sequence

    while ([sequences count] < sequenceCount) {
        [contents enumerateLinesUsingBlock:^(NSString* line, __unused BOOL* stop) {
            NSArray* fields = [line componentsSeparatedByString:@","];
            if ([fields count] < 5) { return; }

            // TODO: format validation & range-checking
            NSInteger color = [fields[0] integerValue];
            double x1 = [fields[1] doubleValue];
            double y1 = [fields[2] doubleValue];
            double x2 = [fields[3] doubleValue];
            double y2 = [fields[4] doubleValue];

            CTDDotColor dotColor = (CTDDotColor)((color - 1 % 3) + CTDDotColor_Red);
            CTDPoint* startPosition = [CTDPoint x:(CTDPointCoordinate)x1
                                                y:(CTDPointCoordinate)y1];
            CTDPoint* endPosition = [CTDPoint x:(CTDPointCoordinate)x2
                                                y:(CTDPointCoordinate)y2];

            CTDDotPair* dotPair = [[CTDDotPair alloc] initWithColor:dotColor
                                                      startPosition:startPosition
                                                        endPosition:endPosition];
            NSLog(@"Loaded: %@", dotPair);

            [dotPairs addObject:dotPair];
            if ([dotPairs count] >= sequenceLength) {
                id<CTDTrialScript> trialScript = [[CTDInMemoryTrialScript alloc]
                                                  initWithDotPairs:dotPairs];
                [sequences addObject:trialScript];
                NSLog(@"-----------------");
                [dotPairs removeAllObjects];

                if ([sequences count] >= sequenceCount) { *stop = YES; return; }
            }
        }];
    }

    return sequences;
}

@end
