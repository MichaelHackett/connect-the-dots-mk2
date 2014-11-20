// CTDDot:
//     A connection target for an exercise trial.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDDotColor.h"

@class CTDPoint;




@interface CTDDot : NSObject

// TODO: Replace properties with a rendering interface?
@property (assign, readonly, nonatomic) CTDDotColor color;
@property (copy, readonly, nonatomic) CTDPoint* position;

- (instancetype)initWithColor:(CTDDotColor)color
                     position:(CTDPoint*)position;

CTD_NO_DEFAULT_INIT

@end
