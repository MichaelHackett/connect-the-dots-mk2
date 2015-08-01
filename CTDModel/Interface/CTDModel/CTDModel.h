// CTDModel:
//     Gateway to the Model module.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTrial;



@interface CTDModel : NSObject

+ (id<CTDTrial>)trialWithDots:(NSArray*)dots;  // array of CTDDots

@end
