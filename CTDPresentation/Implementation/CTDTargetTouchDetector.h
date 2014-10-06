// CTDTargetTouchDetector:
//     Select target when touch detected within its bounds.
//
// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@protocol CTDTargetContainerView;
@protocol CTDTargetSpace;



@interface CTDTargetTouchDetector : NSObject <CTDTouchResponder>

- (instancetype)initWithTargetContainerView:(id<CTDTargetContainerView>)targetContainerView
                                targetSpace:(id<CTDTargetSpace>)targetSpace;
CTD_NO_DEFAULT_INIT

@end
