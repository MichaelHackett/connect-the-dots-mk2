// CTDTouchable:
//     A visual element that responds to touches.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@class CTDPoint;


@protocol CTDTouchable <NSObject>
- (BOOL)containsTouchLocation:(CTDPoint*)touchLocation;
@end
