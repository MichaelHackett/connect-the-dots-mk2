// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDStorage.h"

#import "CTDAppStateFileArchiver.h"
#import "CTDCSVFileWriterFactory.h"



@implementation CTDStorage

+ (id<CTDTrialResultsFactory>)csvFileTrialResultsFactory
{
    return [[CTDCSVFileWriterFactory alloc] init];
}

+ (id<CTDAppStateRecorder>)appStateRecorder
{
    return [[CTDAppStateFileArchiver alloc] init];
}

@end
