// CTDActivateOnTouchInteractor:
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;
@protocol CTDTargetSpace;


@interface CTDActivateOnTouchInteraction : NSObject <CTDTouchTracker>

- (instancetype)initWithTargetSpace:(id<CTDTargetSpace>)targetSpace
               initialTouchPosition:(CTDPoint*)initialPosition;
CTD_NO_DEFAULT_INIT

@end
