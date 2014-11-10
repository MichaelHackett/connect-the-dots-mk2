// CTDTargetConnectionView:
//     Visual representation of a connection between two targets.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@class CTDPoint;



@protocol CTDTargetConnectionView <NSObject>

// Adjust the positions of the ends of the connection (point coordinates are
// relative to the container view).
- (void)setFirstEndpointPosition:(CTDPoint*)firstEndpointPosition;
- (void)setSecondEndpointPosition:(CTDPoint*)secondEndpointPosition;

// Remove the view from the display and do not allow its reuse.
- (void)invalidate;

@end
