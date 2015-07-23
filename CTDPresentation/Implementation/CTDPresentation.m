// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDPresentation.h"

#import "CTDDotSetPresenter.h"
#import "CTDModel/CTDTrial.h"



@implementation CTDPresentation

+ (id<CTDTrialPresenter>)presenterForTrial:(id<CTDTrial>)trial
                             trialRenderer:(id<CTDTrialRenderer>)trialRenderer
{
    return [[CTDDotSetPresenter alloc]
            initWithDotList:[trial dotList]
              trialRenderer:trialRenderer];
}

@end
