// CTDTrialSceneTouchRouter:
//     Handles new touches and decides which tracker to use to act on the input.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@protocol CTDTouchToElementMapper;
@protocol CTDTouchToPointMapper;
@protocol CTDTrialRenderer;
@protocol CTDTrialEditor;



@interface CTDTrialSceneTouchRouter : NSObject <CTDTouchResponder>

@property (weak, nonatomic) id<CTDTrialEditor> trialEditor;
@property (weak, nonatomic) id<CTDTouchToElementMapper> dotsTouchMapper;
@property (weak, nonatomic) id<CTDTouchToPointMapper> freeEndMapper;
@property (weak, nonatomic) id<CTDTouchResponder> colorCellsTouchResponder;

// DEPRECATED
- (instancetype)initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer
                      dotsTouchMapper:(id<CTDTouchToElementMapper>)dotsTouchMapper
                        freeEndMapper:(id<CTDTouchToPointMapper>)freeEndMapper
             colorCellsTouchResponder:(id<CTDTouchResponder>)colorCellsTouchResponder;

@end
