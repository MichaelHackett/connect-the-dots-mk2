// CTDTargetContainerView:
//     The visual representation of a set of targets.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTargetView;
@class CTDPoint;



@protocol CTDTargetContainerView <NSObject>

- (id<CTDTargetView>)newTargetViewCenteredAt:(CTDPoint*)centerPosition;

@end
