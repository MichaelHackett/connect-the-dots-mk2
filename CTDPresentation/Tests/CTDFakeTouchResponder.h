// CTDFakeTouchResponder:
//     Combination test spy and stub for a CTDTouchResponder. Uses a supplied
//     factory block to generate CTDTouchTrackers as required, and records
//     the instances of new touches and the trackers returned (for examination
//     by test verification code).
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@class CTDPoint;



typedef id<CTDTouchTracker> (^CTDTrackerFactoryBlock)(CTDPoint* initialPosition);


@interface CTDFakeTouchResponder : NSObject <CTDTouchResponder>

@property (strong, readonly, nonatomic) NSArray* touchStartingPositions;

- (instancetype)initWithTouchTrackerFactoryBlock:
                    (CTDTrackerFactoryBlock)trackerFactoryBlock;
CTD_NO_DEFAULT_INIT

@end
