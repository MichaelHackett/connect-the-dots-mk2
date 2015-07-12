// CTDDotSetPresenter:
//
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTouchToElementMapper;
@protocol CTDTrialRenderer;



@interface CTDDotSetPresenter : NSObject

- (instancetype)initWithDotList:(NSArray*)dotList
                  trialRenderer:(id<CTDTrialRenderer>)trialRenderer;

CTD_NO_DEFAULT_INIT

- (id<CTDTouchToElementMapper>)dotsTouchMapper;

@end
