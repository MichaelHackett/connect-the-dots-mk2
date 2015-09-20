// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDStorage.h"

#import "CTDCSVFileWriterFactory.h"



@implementation CTDStorage

+ (id<CTDTrialResultsFactory>)csvFileTrialResultsFactory
{
    return [[CTDCSVFileWriterFactory alloc] init];
}

@end
