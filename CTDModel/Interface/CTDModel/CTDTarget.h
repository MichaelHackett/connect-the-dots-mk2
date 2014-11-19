// CTDTarget:
//     A connection target for an exercise trial.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTargetColor.h"

@class CTDPoint;




@interface CTDTarget : NSObject

// TODO: Replace properties with a rendering interface?
@property (assign, readonly, nonatomic) CTDTargetColor color;
@property (copy, readonly, nonatomic) CTDPoint* position;

- (instancetype)initWithColor:(CTDTargetColor)color
                     position:(CTDPoint*)position;

CTD_NO_DEFAULT_INIT

@end
