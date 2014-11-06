// CTDTargetContainerView:
//     The visual representation of a set of targets and connections between
//     them.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTargetView;
@protocol CTDTargetConnectionView;
@protocol CTDTouchable;
@class CTDPoint;



@protocol CTDTargetContainerView <NSObject>

- (id<CTDTargetView, CTDTouchable>)newTargetViewCenteredAt:(CTDPoint*)centerPosition;
- (id<CTDTargetConnectionView>)
      newTargetConnectionViewWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                                secondEndPointPosition:(CTDPoint*)secondEndPointPosition;

@end
