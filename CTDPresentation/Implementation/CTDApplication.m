// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDTargetSetPresenter.h"
#import "CTDTargetTouchDetector.h"
#import "CTDTouchResponder.h"



@implementation CTDApplication
{
    CTDTargetSetPresenter* _currentPresenter;
}

- (void)showTargetSetInRenderer:(id<CTDTargetViewRenderer>)targetViewRenderer
           withTouchInputSource:(id<CTDTouchInputSource>)touchInputSource
{
    _currentPresenter = [[CTDTargetSetPresenter alloc]
                         initWithTargetViewRenderer:targetViewRenderer];
    [touchInputSource addTouchResponder:[[CTDTargetTouchDetector alloc]
                                         initWithTargetSpace:_currentPresenter]];
}

@end
