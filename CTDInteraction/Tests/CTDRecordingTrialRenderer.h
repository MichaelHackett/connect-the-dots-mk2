// CTDRecordingTrialRenderer:
//     A test spy to stand in for a trial renderer.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDTrialRenderer.h"


@interface CTDRecordingTrialRenderer : NSObject <CTDTrialRenderer>

@property (strong, readonly, nonatomic) NSArray* dotRenderersCreated;
@property (strong, readonly, nonatomic) NSArray* connectionRenderersCreated;

@end

