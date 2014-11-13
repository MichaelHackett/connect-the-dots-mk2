// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectOnTapInteraction.h"

#import "CTDTargetRenderer.h"
#import "CTDTouchMapper.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDSelectOnTapInteraction
{
    id<CTDTouchMapper> _touchMapper;
    id<CTDSelectionRenderer> _touchedElement;
}



#pragma mark - Initialization


- (instancetype)initWithTouchMapper:(id<CTDTouchMapper>)touchMapper
               initialTouchPosition:(__unused CTDPoint*)initialPosition
{
    self = [super init];
    if (self) {
        _touchMapper = touchMapper;
        _touchedElement = nil;
        id hitElement = [_touchMapper elementAtTouchLocation:initialPosition];
        if ([hitElement conformsToProtocol:@protocol(CTDSelectionRenderer)]) {
            _touchedElement = (id<CTDSelectionRenderer>)hitElement;
        }
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark - CTDTouchTracker protocol


- (void)touchDidMoveTo:(__unused CTDPoint*)newPosition
{
    id hitElement = [_touchMapper elementAtTouchLocation:newPosition];
    if (!hitElement || [hitElement conformsToProtocol:@protocol(CTDSelectionRenderer)]) {
        _touchedElement = (id<CTDSelectionRenderer>)hitElement;
    }
}

- (void)touchDidEnd
{
    if (_touchedElement) {
        [_touchedElement showSelectionIndicator];
    }
}

// touchWasCancelled is not currently required, because this interaction does
// nothing until the touch is ended (but not cancelled).
//- (void)touchWasCancelled
//{
//}

@end
