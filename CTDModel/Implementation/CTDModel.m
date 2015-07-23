// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDModel.h"

#import "CTDInMemoryTrial.h"



@implementation CTDModel

+ (id<CTDTrial>)trialWithDots:(NSArray *)dots {
    return [[CTDInMemoryTrial alloc] initWithDots:dots];
}

@end
