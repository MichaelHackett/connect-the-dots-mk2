// CTDTouchMapper:
//     Maps touch locations to interface objects; performs a hit-test scan of
//     the touchable elements under its purview. Different implementations may
//     implement priority ordering of overlapping touch-sensitive areas in
//     different ways.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@class CTDPoint;


@protocol CTDTouchMapper <NSObject>
- (id)elementAtTouchLocation:(CTDPoint*)touchLocation;
@end
