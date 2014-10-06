// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDTargetSetPresenter.h"
#import "CTDTargetTouchDetector.h"
#import "CTDTouchResponder.h"



@implementation CTDApplication
{
    CTDTargetSetPresenter* _currentPresenter;
}

- (void)showTargetSetInContainerView:(id<CTDTargetContainerView>)targetContainerView
                withTouchInputSource:(id<CTDTouchInputSource>)touchInputSource
{
    _currentPresenter = [[CTDTargetSetPresenter alloc]
                         initWithTargetContainerView:targetContainerView];
    [touchInputSource addTouchResponder:[[CTDTargetTouchDetector alloc]
                                         initWithTargetContainerView:targetContainerView
                                                         targetSpace:_currentPresenter]];
}

@end
