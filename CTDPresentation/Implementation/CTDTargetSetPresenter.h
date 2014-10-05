// CTDTargetSetPresenter:
//
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTargetSpace.h"

@protocol CTDTargetViewRenderer;



@interface CTDTargetSetPresenter : NSObject <CTDTargetSpace>

- (instancetype)
      initWithTargetViewRenderer:(id<CTDTargetViewRenderer>)targetViewRenderer;

CTD_NO_DEFAULT_INIT

@end
