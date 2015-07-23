// CTDDotSetPresenter:
//
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTrialPresenter.h"

@protocol CTDTouchToElementMapper;
@protocol CTDTrialRenderer;



@interface CTDDotSetPresenter : NSObject <CTDTrialPresenter>

- (instancetype)initWithDotList:(NSArray*)dotList
                  trialRenderer:(id<CTDTrialRenderer>)trialRenderer;

CTD_NO_DEFAULT_INIT

- (id<CTDTouchToElementMapper>)dotsTouchMapper;

@end
