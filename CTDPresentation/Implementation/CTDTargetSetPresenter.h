// CTDTargetSetPresenter:
//
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTargetViewRenderer;



@interface CTDTargetSetPresenter : NSObject

- (instancetype)
      initWithTargetViewRenderer:(id<CTDTargetViewRenderer>)targetViewRenderer;

CTD_NO_DEFAULT_INIT

@end
