// CTDApplication:
//
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDDisplayController;
@protocol CTDRandomalizer;
@protocol CTDTimeSource;
@protocol CTDTrialResultsFactory;



@interface CTDApplication : NSObject

// Designated initializer
- (instancetype)initWithDisplayController:(id<CTDDisplayController>)displayController
                      trialResultsFactory:(id<CTDTrialResultsFactory>)trialResultsFactory
                               timeSource:(id<CTDTimeSource>)timeSource
                             randomalizer:(id<CTDRandomalizer>)randomalizer;

CTD_NO_DEFAULT_INIT


- (void)start;

@end
