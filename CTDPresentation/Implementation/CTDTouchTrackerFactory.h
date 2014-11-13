// CTDTouchTrackerFactory:
//     A CTDTouchResponder that creates CTDTouchTrackers on demand, for each
//     new touch to be tracked.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchResponder.h"

@protocol CTDTouchTracker;


typedef id<CTDTouchTracker> (^CTDTouchTrackerFactoryBlock)(CTDPoint* initialPosition);


@interface CTDTouchTrackerFactory : NSObject <CTDTouchResponder>

- (instancetype)initWithTouchTrackerFactoryBlock:
                    (CTDTouchTrackerFactoryBlock)trackerFactoryBlock;
CTD_NO_DEFAULT_INIT

@end
