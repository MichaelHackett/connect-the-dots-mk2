// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDSelectOnTouchInteraction.h"

#import "CTDTouchMapper.h"
#import "CTDPresentation/CTDSelectable.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDSelectOnTouchInteraction
{
    id<CTDTouchMapper> _touchMapper;
    id<CTDSelectable> _selectedElement;
}



#pragma mark Initialization


- (instancetype)initWithTouchMapper:(id<CTDTouchMapper>)touchMapper
                initialTouchPosition:(CTDPoint*)initialPosition
{
    self = [super init];
    if (self) {
        _touchMapper = touchMapper;
        _selectedElement = nil;
        id hitElement = [_touchMapper elementAtTouchLocation:initialPosition];
        if ([hitElement conformsToProtocol:@protocol(CTDSelectable)]) {
            _selectedElement = (id<CTDSelectable>)hitElement;
            [_selectedElement select];
        }
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    id hitElement = [_touchMapper elementAtTouchLocation:newPosition];
    if (hitElement != _selectedElement &&
        (!hitElement ||
         [hitElement conformsToProtocol:@protocol(CTDSelectable)]))
    {
        if (_selectedElement) {
            [_selectedElement deselect];
        }
        _selectedElement = (id<CTDSelectable>)hitElement;
        [_selectedElement select];
    }
}

- (void)touchDidEnd
{
    if (_selectedElement) {
        [_selectedElement deselect];
    }
}

- (void)touchWasCancelled
{
    if (_selectedElement) {
        [_selectedElement deselect];
    }
}

@end
