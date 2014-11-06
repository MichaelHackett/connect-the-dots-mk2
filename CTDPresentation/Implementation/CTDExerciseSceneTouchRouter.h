// CTDExerciseSceneTouchRouter:
//     Handles new touches and decides which tracker to use to act on the input.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@protocol CTDTargetContainerView;
@protocol CTDTouchMapper;



@interface CTDExerciseSceneTouchRouter : NSObject <CTDTouchResponder>

- (instancetype)initWithTargetContainerView:
                    (id<CTDTargetContainerView>)targetContainerView
                targetsTouchMapper:(id<CTDTouchMapper>)targetsTouchMapper;
CTD_NO_DEFAULT_INIT

@end
