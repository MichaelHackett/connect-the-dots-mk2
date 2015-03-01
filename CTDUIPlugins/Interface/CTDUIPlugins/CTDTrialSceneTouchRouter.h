// CTDTrialSceneTouchRouter:
//     Handles new touches and decides which tracker to use to act on the input.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIBridge/ExtensionPoints/CTDTouchResponder.h"

@protocol CTDTouchMapper;
@protocol CTDTrialRenderer;



@interface CTDTrialSceneTouchRouter : NSObject <CTDTouchResponder>

- (instancetype)initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer
                      dotsTouchMapper:(id<CTDTouchMapper>)dotsTouchMapper
             colorCellsTouchResponder:(id<CTDTouchResponder>)colorCellsTouchResponder;
CTD_NO_DEFAULT_INIT

@end
