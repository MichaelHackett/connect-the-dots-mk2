// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectOnTouchInteraction.h"

#import "CTDTargetRenderer.h"
#import "CTDTouchMapper.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDSelectOnTouchInteraction
{
    id<CTDTouchMapper> _touchMapper;
    id<CTDSelectionRenderer> _selectedElement;
}



#pragma mark - Initialization


- (instancetype)initWithTouchMapper:(id<CTDTouchMapper>)touchMapper
                initialTouchPosition:(CTDPoint*)initialPosition
{
    self = [super init];
    if (self) {
        _touchMapper = touchMapper;
        _selectedElement = nil;
        id hitElement = [_touchMapper elementAtTouchLocation:initialPosition];
        if ([hitElement conformsToProtocol:@protocol(CTDSelectionRenderer)]) {
            _selectedElement = (id<CTDSelectionRenderer>)hitElement;
            [_selectedElement showSelectionIndicator];
        }
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark - CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    id hitElement = [_touchMapper elementAtTouchLocation:newPosition];
    if (hitElement != _selectedElement &&
        (!hitElement ||
         [hitElement conformsToProtocol:@protocol(CTDSelectionRenderer)]))
    {
        if (_selectedElement) {
            [_selectedElement hideSelectionIndicator];
        }
        _selectedElement = (id<CTDSelectionRenderer>)hitElement;
        [_selectedElement showSelectionIndicator];
    }
}

- (void)touchDidEnd
{
    if (_selectedElement) {
        [_selectedElement hideSelectionIndicator];
    }
}

- (void)touchWasCancelled
{
    if (_selectedElement) {
        [_selectedElement hideSelectionIndicator];
    }
}

@end
