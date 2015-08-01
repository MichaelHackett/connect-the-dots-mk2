// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitTouchRoutingTable.h"


static id<NSCopying> keyForTouch(UITouch* touch)
{
    return [NSValue valueWithNonretainedObject:touch];
}


@implementation CTDUIKitTouchRoutingTable
{
    NSMutableDictionary* _touchTrackerMap;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _touchTrackerMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setTracker:(id<CTDTouchTracker>)touchTracker forTouch:(UITouch*)touch
{
    id key = keyForTouch(touch);
    if (touchTracker) {
        [_touchTrackerMap setObject:touchTracker forKey:key];
    } else {
        [_touchTrackerMap removeObjectForKey:key];
    }
}

- (id<CTDTouchTracker>)trackerForTouch:(UITouch*)touch
{
    return [_touchTrackerMap objectForKey:keyForTouch(touch)];
}

@end
