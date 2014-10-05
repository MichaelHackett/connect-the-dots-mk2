// CTDTargetTouchDetector:
//     Select target when touch detected within its bounds.
//
// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@protocol CTDTargetSpace;



@interface CTDTargetTouchDetector : NSObject <CTDTouchResponder>

- (instancetype)initWithTargetSpace:(id<CTDTargetSpace>)targetSpace;
CTD_NO_DEFAULT_INIT

@end
