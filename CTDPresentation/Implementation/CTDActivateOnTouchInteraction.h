// CTDActivateOnTouchInteractor:
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;
@protocol CTDTouchMapper;


@interface CTDActivateOnTouchInteraction : NSObject <CTDTouchTracker>

- (instancetype)initWithTargetTouchMapper:(id<CTDTouchMapper>)targetTouchMapper
                     initialTouchPosition:(CTDPoint*)initialPosition;
CTD_NO_DEFAULT_INIT

@end
