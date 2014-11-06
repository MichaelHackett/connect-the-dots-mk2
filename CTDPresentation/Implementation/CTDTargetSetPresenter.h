// CTDTargetSetPresenter:
//
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTargetContainerView;
@protocol CTDTouchMapper;



@interface CTDTargetSetPresenter : NSObject

- (instancetype)initWithTargetContainerView:
                    (id<CTDTargetContainerView>)targetContainerView;
// TODO: pass target-set argument

CTD_NO_DEFAULT_INIT

- (id<CTDTouchMapper>)targetsTouchMapper;

@end
