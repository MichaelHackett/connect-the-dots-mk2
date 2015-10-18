// CTDStorage:
//     Gateway to the Storage module.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDAppStateRecorder;
@protocol CTDTrialResultsFactory;



@interface CTDStorage : NSObject

+ (id<CTDTrialResultsFactory>)csvFileTrialResultsFactory;
+ (id<CTDAppStateRecorder>)appStateRecorder;

@end
