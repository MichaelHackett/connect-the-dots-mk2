// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDModel.h"

#import "CTDDotPair.h"
#import "CTDInMemoryTrial.h"



@implementation CTDModel

+ (CTDDotPair*)dotPairWithColor:(CTDDotColor)color
                  startPosition:(CTDPoint*)startPosition
                    endPosition:(CTDPoint*)endPosition
{
    return [[CTDDotPair alloc] initWithColor:color
                               startPosition:startPosition
                                 endPosition:endPosition];
}

+ (id<CTDTrial>)trialWithDotPairs:(NSArray*)dotPairs
{
    return [[CTDInMemoryTrial alloc] initWithDotPairs:dotPairs];
}

@end
