// CTDDotPair:
//     Defines a pair of dots and a color as one step in an exercise trial.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDDotColor.h"

@class CTDPoint;




@interface CTDDotPair : NSObject <NSCopying>

// TODO: Replace properties with a rendering interface?
@property (assign, readonly, nonatomic) CTDDotColor color;
@property (copy, readonly, nonatomic) CTDPoint* startPosition;
@property (copy, readonly, nonatomic) CTDPoint* endPosition;

- (instancetype)initWithColor:(CTDDotColor)color
                startPosition:(CTDPoint*)startPosition
                  endPosition:(CTDPoint*)endPosition;

CTD_NO_DEFAULT_INIT


- (BOOL)isEqualToDotPair:(CTDDotPair*)otherDotPair;

@end
