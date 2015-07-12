// CTDTrialSceneTouchRouter:
//     Handles new touches and decides which tracker to use to act on the input.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@protocol CTDTouchToElementMapper;
@protocol CTDTouchToPointMapper;
@protocol CTDTrialRenderer;



@interface CTDTrialSceneTouchRouter : NSObject <CTDTouchResponder>

- (instancetype)initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer
                      dotsTouchMapper:(id<CTDTouchToElementMapper>)dotsTouchMapper
                        freeEndMapper:(id<CTDTouchToPointMapper>)freeEndMapper
             colorCellsTouchResponder:(id<CTDTouchResponder>)colorCellsTouchResponder;
CTD_NO_DEFAULT_INIT

@end
