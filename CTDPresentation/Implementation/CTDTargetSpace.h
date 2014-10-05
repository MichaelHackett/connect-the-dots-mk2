// CTDTargetSpace:
//     Holds a set of targets in a 2D geometric space. Within this container
//     targets have a shape and cover some area of the space.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@class CTDPoint;
@protocol CTDTargetView;


@protocol CTDTargetSpace <NSObject>

- (id<CTDTargetView>)targetAtLocation:(CTDPoint*)location;

@end
