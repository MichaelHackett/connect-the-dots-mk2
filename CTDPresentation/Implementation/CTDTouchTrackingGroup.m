// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchTrackingGroup.h"



@implementation CTDTouchTrackingGroup
{
    NSMutableArray* _touchTrackers;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _touchTrackers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addTracker:(id<CTDTouchTracker>)touchTracker
{
    [_touchTrackers addObject:touchTracker];
}

- (void)removeTracker:(__unused id<CTDTouchTracker>)touchTracker
{

}



#pragma mark - CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    for (id<CTDTouchTracker> tracker in _touchTrackers) {
        [tracker touchDidMoveTo:newPosition];
    }
}

- (void)touchDidEnd
{
    for (id<CTDTouchTracker> tracker in _touchTrackers) {
        [tracker touchDidEnd];
    }
}

- (void)touchWasCancelled
{
    for (id<CTDTouchTracker> tracker in _touchTrackers) {
        [tracker touchWasCancelled];
    }
}

@end
