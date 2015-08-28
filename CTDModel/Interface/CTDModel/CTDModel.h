// CTDModel:
//     Gateway to the Model module.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDDotColor.h"
@class CTDDotPair;
@class CTDPoint;
@protocol CTDTrial;



@interface CTDModel : NSObject

+ (CTDDotPair*)dotPairWithColor:(CTDDotColor)color
                  startPosition:(CTDPoint*)startPosition
                    endPosition:(CTDPoint*)endPosition;

+ (id<CTDTrial>)trialWithDotPairs:(NSArray*)dotPairs;  // array of CTDDotPairs

@end
