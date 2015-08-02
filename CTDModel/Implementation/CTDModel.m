// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDModel.h"

#import "CTDDot.h"
#import "CTDInMemoryTrial.h"



@implementation CTDModel

+ (CTDDot*)dotWithColor:(CTDDotColor)color
               position:(CTDPoint*)position
{
    return [[CTDDot alloc] initWithColor:color position:position];
}

+ (id<CTDTrial>)trialWithDots:(NSArray *)dots
{
    return [[CTDInMemoryTrial alloc] initWithDots:dots];
}

@end
