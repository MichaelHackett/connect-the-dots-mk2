// CTDTargetSetPresenter:
//
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTargetSpace.h"

@protocol CTDTargetContainerView;



@interface CTDTargetSetPresenter : NSObject <CTDTargetSpace>

- (instancetype)initWithTargetContainerView:
                        (id<CTDTargetContainerView>)targetContainerView;

CTD_NO_DEFAULT_INIT

@end
