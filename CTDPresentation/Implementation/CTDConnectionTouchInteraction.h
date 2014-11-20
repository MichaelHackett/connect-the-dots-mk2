// CTDConnectionTouchInteraction:
//     Handles dragging between elements to connect them.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;
@protocol CTDDotRenderer;
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
             dotTouchMapper:(id<CTDTouchMapper>)dotTouchMapper
              anchorDotView:(id<CTDDotRenderer>)anchorDotView
     initialFreeEndPosition:(CTDPoint*)initialFreeEndPosition;
CTD_NO_DEFAULT_INIT

@end
