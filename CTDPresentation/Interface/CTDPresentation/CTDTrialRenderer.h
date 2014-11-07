// CTDTrialRenderer:
//     The visual representation of a connect-the-dots trial, containing a set
//     of targets and connections between them, plus the color selection tool.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTargetRenderer;
@protocol CTDTargetConnectionView;
@protocol CTDTouchable;
@class CTDPoint;



@protocol CTDTrialRenderer <NSObject>

- (id<CTDTargetRenderer, CTDTouchable>)newTargetViewCenteredAt:(CTDPoint*)centerPosition;
- (id<CTDTargetConnectionView>)
      newTargetConnectionViewWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                                secondEndpointPosition:(CTDPoint*)secondEndpointPosition;

@end
