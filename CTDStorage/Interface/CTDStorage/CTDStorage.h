// CTDStorage:
//     Gateway to the Storage module.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTrialResultsFactory;



@interface CTDStorage : NSObject

+ (id<CTDTrialResultsFactory>)csvFileTrialResultsFactory;

@end
