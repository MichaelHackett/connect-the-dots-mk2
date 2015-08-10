// CTDConnectionTouchInteraction:
//     Handles dragging between elements to connect them.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;
@protocol CTDTouchToElementMapper;
@protocol CTDTouchToPointMapper;
@protocol CTDTrialStepConnectionEditor;



//
// Candidates for connection (must support touch detection and have a
// connection point).
//
//@protocol CTDConnectableByTouch <CTDConnectable, CTDTouchable>
//@end



@interface CTDConnectionTouchInteraction : NSObject <CTDTouchTracker>

// Designated initializer
- (instancetype)
      initWithConnectionEditor:(id<CTDTrialStepConnectionEditor>)connectionEditor
                dotTouchMapper:(id<CTDTouchToElementMapper>)dotTouchMapper
                 freeEndMapper:(id<CTDTouchToPointMapper>)freeEndMapper
          initialTouchPosition:(CTDPoint*)initialPosition;

CTD_NO_DEFAULT_INIT

@end
