// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDApplication.h"

#import "CTDTargetSetPresenter.h"



@implementation CTDApplication
{
    CTDTargetSetPresenter* _currentPresenter;
}

- (void)showTargetSetInRenderer:(id<CTDTargetViewRenderer>)targetViewRenderer
{
    _currentPresenter = [[CTDTargetSetPresenter alloc]
                         initWithTargetViewRenderer:targetViewRenderer];
}

@end
