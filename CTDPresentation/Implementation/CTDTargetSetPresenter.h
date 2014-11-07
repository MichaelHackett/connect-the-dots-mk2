// CTDTargetSetPresenter:
//
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTouchMapper;
@protocol CTDTrialRenderer;



@interface CTDTargetSetPresenter : NSObject

- (instancetype)initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer;
// TODO: pass target-set argument

CTD_NO_DEFAULT_INIT

- (id<CTDTouchMapper>)targetsTouchMapper;

@end
