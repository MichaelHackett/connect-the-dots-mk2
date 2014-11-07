// CTDConnectionTouchInteraction:
//     Handles dragging between elements to connect them.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;
@protocol CTDTargetRenderer;
@protocol CTDTouchMapper;
@protocol CTDTrialRenderer;



//
// Candidates for connection (must support touch detection and have a
// connection point).
//
//@protocol CTDConnectableByTouch <CTDConnectable, CTDTouchable>
//@end



@interface CTDConnectionTouchInteraction : NSObject <CTDTouchTracker>

// Designated initializer
- (instancetype)
      initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer
          targetTouchMapper:(id<CTDTouchMapper>)targetTouchMapper
           anchorTargetView:(id<CTDTargetRenderer>)anchorTargetView
     initialFreeEndPosition:(CTDPoint*)initialFreeEndPosition;
CTD_NO_DEFAULT_INIT

@end
