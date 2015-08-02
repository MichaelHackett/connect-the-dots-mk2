// CTDModel:
//     Gateway to the Model module.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDDotColor.h"
@class CTDDot;
@class CTDPoint;
@protocol CTDTrial;



@interface CTDModel : NSObject

+ (CTDDot*)dotWithColor:(CTDDotColor)color
               position:(CTDPoint*)position;

+ (id<CTDTrial>)trialWithDots:(NSArray*)dots;  // array of CTDDots

@end
