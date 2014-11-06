// CTDSelectOnTouchInteraction:
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;
@protocol CTDTouchMapper;



// TODO: Make this work against a generic "Selectable" protocol, instead of
// just TargetViews.

@interface CTDSelectOnTouchInteraction : NSObject <CTDTouchTracker>

- (instancetype)initWithTargetTouchMapper:(id<CTDTouchMapper>)targetTouchMapper
                     initialTouchPosition:(CTDPoint*)initialPosition;
CTD_NO_DEFAULT_INIT

@end
