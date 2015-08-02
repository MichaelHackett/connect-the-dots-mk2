// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDPresentation.h"

#import "CTDDotSetPresenter.h"
#import "CTDModel/CTDTrial.h"



@implementation CTDPresentation

+ (id<CTDTrialActivityView>)
      trialActivityViewForTrial:(id<CTDTrial>)trial
                  trialRenderer:(id<CTDTrialRenderer>)trialRenderer
{
    return [[CTDDotSetPresenter alloc]
            initWithDotPairs:[trial dotPairs]
               trialRenderer:trialRenderer];
}

@end
