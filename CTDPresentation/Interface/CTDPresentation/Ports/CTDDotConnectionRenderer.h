// CTDDotConnectionRenderer:
//     An entity that renders a dot-to-dot connection into another form
//     (typically visual).
//
// Copyright 2014 Michael Hackett. All rights reserved.

@class CTDPoint;



@protocol CTDDotConnectionRenderer <NSObject>

// Adjust the positions of the ends of the connection (point coordinates are
// relative to the display container).
- (void)setFirstEndpointPosition:(CTDPoint*)firstEndpointPosition;
- (void)setSecondEndpointPosition:(CTDPoint*)secondEndpointPosition;

// Remove the rendering from the display and do not allow its reuse.
- (void)invalidate;

@end
