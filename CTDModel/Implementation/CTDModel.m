// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDModel.h"

#import "CTDDotPair.h"
#import "CTDInMemoryTrialResults.h"
#import "CTDInMemoryTrialScript.h"



@implementation CTDModel

+ (CTDDotPair*)dotPairWithColor:(CTDDotColor)color
                  startPosition:(CTDPoint*)startPosition
                    endPosition:(CTDPoint*)endPosition
{
    return [[CTDDotPair alloc] initWithColor:color
                               startPosition:startPosition
                                 endPosition:endPosition];
}

+ (id<CTDTrialScript>)trialScriptWithDotPairs:(NSArray*)dotPairs
{
    return [[CTDInMemoryTrialScript alloc] initWithDotPairs:dotPairs];
}

+ (id<CTDTrialResults>)trialResultsHolder
{
    return [[CTDInMemoryTrialResults alloc] init];
}

@end
