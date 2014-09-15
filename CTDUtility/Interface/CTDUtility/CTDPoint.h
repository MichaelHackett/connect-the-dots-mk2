// CTDPoint:
//     A value object representing a point in 2D space.
//
// Copyright 2014 Michael Hackett. All rights reserved.


typedef float CTDPointCoordinate;  // might want to change to double on some platforms


@interface CTDPoint : NSObject <NSCopying>

@property (readonly, nonatomic) CTDPointCoordinate x;
@property (readonly, nonatomic) CTDPointCoordinate y;

// Designated initializer
- (instancetype)initWithX:(CTDPointCoordinate)x
                        y:(CTDPointCoordinate)y;

// Convenience constructor
+ (instancetype)x:(CTDPointCoordinate)x y:(CTDPointCoordinate)y;

+ (instancetype)origin;

- (BOOL)isEqualToPoint:(CTDPoint*)otherPoint;

@end
