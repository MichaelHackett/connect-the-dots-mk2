// CTDDotSetPresenter:
//
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTrialActivityView.h"

@protocol CTDTouchToElementMapper;
@protocol CTDTrialRenderer;



@interface CTDDotSetPresenter : NSObject <CTDTrialActivityView>

- (instancetype)initWithDotPairs:(NSArray*)dotPairs
                   trialRenderer:(id<CTDTrialRenderer>)trialRenderer;

CTD_NO_DEFAULT_INIT

- (id<CTDTouchToElementMapper>)dotsTouchMapper;

@end
