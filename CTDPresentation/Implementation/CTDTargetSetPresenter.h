// CTDTargetSetPresenter:
//
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTouchMapper;
@protocol CTDTrialRenderer;



@interface CTDTargetSetPresenter : NSObject

- (instancetype)initWithTargetList:(NSArray*)targetList
                     trialRenderer:(id<CTDTrialRenderer>)trialRenderer;

CTD_NO_DEFAULT_INIT

- (id<CTDTouchMapper>)targetsTouchMapper;

@end
