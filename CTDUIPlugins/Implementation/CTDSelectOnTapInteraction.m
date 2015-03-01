// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectOnTapInteraction.h"

#import "CTDSelectable.h"
#import "CTDTouchMapper.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDSelectOnTapInteraction
{
    id<CTDTouchMapper> _touchMapper;
    id<CTDSelectable> _touchedElement;
}



#pragma mark Initialization


- (instancetype)initWithTouchMapper:(id<CTDTouchMapper>)touchMapper
               initialTouchPosition:(CTDPoint*)initialPosition
{
    self = [super init];
    if (self) {
        _touchMapper = touchMapper;
        _touchedElement = nil;
        id hitElement = [_touchMapper elementAtTouchLocation:initialPosition];
        if ([hitElement conformsToProtocol:@protocol(CTDSelectable)]) {
            _touchedElement = (id<CTDSelectable>)hitElement;
        }
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    id hitElement = [_touchMapper elementAtTouchLocation:newPosition];
    if (!hitElement || [hitElement conformsToProtocol:@protocol(CTDSelectable)]) {
        _touchedElement = (id<CTDSelectable>)hitElement;
    }
}

- (void)touchDidEnd
{
    if (_touchedElement) {
        [_touchedElement select];
    }
}

// touchWasCancelled is not currently required, because this interaction does
// nothing until the touch is ended (but not cancelled).
//- (void)touchWasCancelled
//{
//}

@end
