// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDConnectionTouchInteraction.h"

#import "CTDDotConnectionRenderer.h"
#import "CTDDotRenderer.h"
#import "CTDTouchMapper.h"
#import "CTDTrialRenderer.h"
#import "CTDUtility/CTDPoint.h"



//typedef enum {
//    CTDConnectionInteractionPhaseNotYetActive,
//    CTDConnectionInteractionPhaseAnchored
////    CTDConnectionInteractionConnected
//} CTDConnectionInteractionPhase;



@interface CTDConnectionPresenter : NSObject

- (instancetype)initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer;
- (void)anchorOnDotView:(id<CTDDotRenderer>)dotView;
- (void)connectFreeEndToDotView:(id<CTDDotRenderer>)dotView
               orMoveToPosition:(CTDPoint*)freeEndPosition;
- (void)cancelConnection;

@end





@implementation CTDConnectionTouchInteraction
{
    id<CTDTouchMapper> _dotTouchMapper;
    CTDConnectionPresenter* _presenter;
    id<CTDDotRenderer> _anchorDotView;
}



#pragma mark Initialization


- (instancetype)
      initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer
             dotTouchMapper:(id<CTDTouchMapper>)dotTouchMapper
              anchorDotView:(id<CTDDotRenderer>)anchorDotView
     initialFreeEndPosition:(CTDPoint*)initialFreeEndPosition
{
    self = [super init];
    if (self) {
        if (!anchorDotView) {
            [NSException raise:NSInvalidArgumentException
                        format:@"Anchor dot view must not be nil"];
        }
        _dotTouchMapper = dotTouchMapper;
        _presenter = [[CTDConnectionPresenter alloc]
                      initWithTrialRenderer:trialRenderer];

        _anchorDotView = anchorDotView;
        [_presenter anchorOnDotView:_anchorDotView];
        [_presenter connectFreeEndToDotView:nil
                           orMoveToPosition:initialFreeEndPosition];
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    id<CTDDotRenderer> connectedDotView = nil;
    id hitElement = [_dotTouchMapper elementAtTouchLocation:newPosition];
    if (hitElement &&
        hitElement != _anchorDotView &&
        [hitElement conformsToProtocol:@protocol(CTDDotRenderer)])
    {
        connectedDotView = (id<CTDDotRenderer>)hitElement;
    }

    [_presenter connectFreeEndToDotView:connectedDotView
                       orMoveToPosition:newPosition];
}

- (void)touchDidEnd
{
    [self touchWasCancelled];
}

- (void)touchWasCancelled
{
    [_presenter cancelConnection];
}

@end





@implementation CTDConnectionPresenter
{
    __weak id<CTDTrialRenderer> _trialRenderer;
    id<CTDDotRenderer> _anchorDotView;
    id<CTDDotRenderer> _freeEndDotView;
    id<CTDDotConnectionRenderer> _connectionView;
}

- (instancetype)initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer
{
    self = [super init];
    if (self) {
        _trialRenderer = trialRenderer;
        _anchorDotView = nil;
        _freeEndDotView = nil;
        _connectionView = nil;
    }
    return self;
}

- (void)anchorOnDotView:(id<CTDDotRenderer>)dotView
{
    if (_anchorDotView != dotView) {
        if (_anchorDotView) {
            [_anchorDotView hideSelectionIndicator];
        }
        _anchorDotView = dotView;
        [dotView showSelectionIndicator];
        if (_connectionView) {
            // Anchor must always be set before free end, so we never need to
            // *create* the connection view here; just update it if it exists.
            [_connectionView setFirstEndpointPosition:[dotView connectionPoint]];
        }
    }
}

- (void)connectFreeEndToDotView:(id<CTDDotRenderer>)dotView
               orMoveToPosition:(CTDPoint*)freeEndPosition
{
    NSAssert(_anchorDotView,
             @"Connection must be anchored before free end can be moved.");

    if (_freeEndDotView && (_freeEndDotView == dotView)) {
        return;
    }

    if (_freeEndDotView) {
        [_freeEndDotView hideSelectionIndicator];
    }
    _freeEndDotView = dotView;
    if (dotView) {
        [dotView showSelectionIndicator];
        // snap end of connection to dot's connection point
        freeEndPosition = [dotView connectionPoint];
    }

    if (!_connectionView) {
        id<CTDTrialRenderer> trialRenderer = _trialRenderer;
        CTDPoint* anchorPosition = [_anchorDotView connectionPoint];
        _connectionView = [trialRenderer
                           newDotConnectionViewWithFirstEndpointPosition:anchorPosition
                           secondEndpointPosition:freeEndPosition];
    } else {
        [_connectionView setSecondEndpointPosition:freeEndPosition];
    }
}

- (void)cancelConnection
{
    [_connectionView invalidate];
    _connectionView = nil;
    [_anchorDotView hideSelectionIndicator];
    [_freeEndDotView hideSelectionIndicator];
}

@end
