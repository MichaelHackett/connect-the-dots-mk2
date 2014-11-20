// CTDDotSetPresenter:
//
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTouchMapper;
@protocol CTDTrialRenderer;



@interface CTDDotSetPresenter : NSObject

- (instancetype)initWithDotList:(NSArray*)dotList
                  trialRenderer:(id<CTDTrialRenderer>)trialRenderer;

CTD_NO_DEFAULT_INIT

- (id<CTDTouchMapper>)dotsTouchMapper;

@end
