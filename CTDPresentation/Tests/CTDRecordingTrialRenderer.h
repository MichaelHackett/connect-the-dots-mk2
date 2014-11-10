// CTDRecordingTrialRenderer:
//     A test spy to stand in for a trial renderer.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTrialRenderer.h"


@interface CTDRecordingTrialRenderer : NSObject <CTDTrialRenderer>

@property (strong, readonly, nonatomic) NSArray* targetViewsCreated;
@property (strong, readonly, nonatomic) NSArray* targetConnectionViewsCreated;

@end

