// CTDConnectionTouchInteraction:
//     Handles dragging between elements to connect them.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;
@protocol CTDDotRenderer;
@protocol CTDTouchToElementMapper;
@protocol CTDTrialRenderer;
@protocol CTDTouchToPointMapper;



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
             dotTouchMapper:(id<CTDTouchToElementMapper>)dotTouchMapper
              freeEndMapper:(id<CTDTouchToPointMapper>)freeEndMapper
              anchorDotView:(id<CTDDotRenderer>)anchorDotView
     initialFreeEndPosition:(CTDPoint*)initialFreeEndPosition;
CTD_NO_DEFAULT_INIT

@end