// CTDTouchMappers:
//     Maps touch positions to a local coordinate system, a range of values, or
//     a set of objects. There are different mapper protocols for different
//     target ranges and types. (Currently only points and elements are
//     implemented, but it would be easy to add types for things like 1-D
//     sliders or 3-D spaces.)
//
// Copyright 2015 Michael Hackett. All rights reserved.

@class CTDPoint;


// Maps to a 2D-coordinate space.
@protocol CTDTouchToPointMapper <NSObject>
- (CTDPoint*)pointAtTouchLocation:(CTDPoint*)touchLocation;
@end


// Maps touch locations to interaction objects; the priority ordering of
// overlapping objects is implementation specific.
@protocol CTDTouchToElementMapper <NSObject>
- (id)elementAtTouchLocation:(CTDPoint*)touchLocation;
@end
