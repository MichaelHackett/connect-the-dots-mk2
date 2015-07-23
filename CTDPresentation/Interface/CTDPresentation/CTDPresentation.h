// CTDPresentation:
//     Gateway to the Presentation module. Includes factories for the public
//     interfaces of the module (or will, over time).
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTrial;
@protocol CTDTrialPresenter;
@protocol CTDTrialRenderer;



@interface CTDPresentation : NSObject

+ (id<CTDTrialPresenter>)presenterForTrial:(id<CTDTrial>)trial
                             trialRenderer:(id<CTDTrialRenderer>)trialRenderer;

@end
