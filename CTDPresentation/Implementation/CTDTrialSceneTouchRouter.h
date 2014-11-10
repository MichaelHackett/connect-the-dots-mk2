// CTDTrialSceneTouchRouter:
//     Handles new touches and decides which tracker to use to act on the input.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@protocol CTDTouchMapper;
@protocol CTDTrialRenderer;



@interface CTDTrialSceneTouchRouter : NSObject <CTDTouchResponder>

- (instancetype)initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer
                   targetsTouchMapper:(id<CTDTouchMapper>)targetsTouchMapper
              colorButtonsTouchMapper:(id<CTDTouchMapper>)colorButtonsTouchMapper;
CTD_NO_DEFAULT_INIT

@end