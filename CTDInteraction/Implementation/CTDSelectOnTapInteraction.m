// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDSelectOnTapInteraction.h"

#import "Ports/CTDTouchMappers.h"
#import "CTDPresentation/CTDSelectable.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDSelectOnTapInteraction
{
    id<CTDTouchToElementMapper> _touchMapper;
    id<CTDSelectable> _touchedElement;
}



#pragma mark Initialization


- (instancetype)initWithTouchMapper:(id<CTDTouchToElementMapper>)touchMapper
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
