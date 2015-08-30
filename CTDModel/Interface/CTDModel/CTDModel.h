// CTDModel:
//     Gateway to the Model module.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDDotColor.h"
@class CTDDotPair;
@class CTDPoint;
@protocol CTDTrialScript;



@interface CTDModel : NSObject

+ (CTDDotPair*)dotPairWithColor:(CTDDotColor)color
                  startPosition:(CTDPoint*)startPosition
                    endPosition:(CTDPoint*)endPosition;

+ (id<CTDTrialScript>)trialScriptWithDotPairs:(NSArray*)dotPairs;  // array of CTDDotPairs

@end
