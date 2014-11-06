// CTDConnectionTouchInteraction:
//     Handles dragging between elements to connect them.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;
@protocol CTDTargetContainerView;
@protocol CTDTouchMapper;
@protocol CTDTargetView;



//
// Candidates for connection (must support touch detection and have a
// connection point).
//
//@protocol CTDConnectableByTouch <CTDConnectable, CTDTouchable>
//@end



@interface CTDConnectionTouchInteraction : NSObject <CTDTouchTracker>

// Designated initializer
- (instancetype)
      initWithTargetContainerView:(id<CTDTargetContainerView>)targetContainerView
                targetTouchMapper:(id<CTDTouchMapper>)targetTouchMapper
                 anchorTargetView:(id<CTDTargetView>)anchorTargetView
           initialFreeEndPosition:(CTDPoint*)initialFreeEndPosition;
CTD_NO_DEFAULT_INIT

@end
