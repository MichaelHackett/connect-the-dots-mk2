// CTDTargetContainerView:
//     The visual representation of a set of targets and connections between
//     them.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTargetView;
@protocol CTDTargetConnectionView;
@class CTDPoint;



@protocol CTDTargetContainerView <NSObject>

- (id<CTDTargetView>)newTargetViewCenteredAt:(CTDPoint*)centerPosition;
- (id<CTDTargetConnectionView>)
      newTargetConnectionViewWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                                secondEndPointPosition:(CTDPoint*)secondEndPointPosition;

@end
