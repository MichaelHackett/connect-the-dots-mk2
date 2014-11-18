// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDConnectionTouchInteraction.h"

#import "CTDTargetConnectionView.h"
#import "CTDTargetRenderer.h"
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
- (void)anchorOnTargetView:(id<CTDTargetRenderer>)targetView;
- (void)connectFreeEndToTargetView:(id<CTDTargetRenderer>)targetView
                  orMoveToPosition:(CTDPoint*)freeEndPosition;
- (void)cancelConnection;

@end





@implementation CTDConnectionTouchInteraction
{
    id<CTDTouchMapper> _targetTouchMapper;
    CTDConnectionPresenter* _presenter;
    id<CTDTargetRenderer> _anchorTargetView;
}



#pragma mark Initialization


- (instancetype)
      initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer
          targetTouchMapper:(id<CTDTouchMapper>)targetTouchMapper
           anchorTargetView:(id<CTDTargetRenderer>)anchorTargetView
     initialFreeEndPosition:(CTDPoint*)initialFreeEndPosition
{
    self = [super init];
    if (self) {
        if (!anchorTargetView) {
            [NSException raise:NSInvalidArgumentException
                        format:@"Anchor target view must not be nil"];
        }
        _targetTouchMapper = targetTouchMapper;
        _presenter = [[CTDConnectionPresenter alloc]
                      initWithTrialRenderer:trialRenderer];

        _anchorTargetView = anchorTargetView;
        [_presenter anchorOnTargetView:_anchorTargetView];
        [_presenter connectFreeEndToTargetView:nil
                              orMoveToPosition:initialFreeEndPosition];
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    id<CTDTargetRenderer> connectedTargetView = nil;
    id hitElement = [_targetTouchMapper elementAtTouchLocation:newPosition];
    if (hitElement &&
        hitElement != _anchorTargetView &&
        [hitElement conformsToProtocol:@protocol(CTDTargetRenderer)])
    {
        connectedTargetView = (id<CTDTargetRenderer>)hitElement;
    }

    [_presenter connectFreeEndToTargetView:connectedTargetView
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
    id<CTDTargetRenderer> _anchorTargetView;
    id<CTDTargetRenderer> _freeEndTargetView;
    id<CTDTargetConnectionView> _connectionView;
}

- (instancetype)initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer
{
    self = [super init];
    if (self) {
        _trialRenderer = trialRenderer;
        _anchorTargetView = nil;
        _connectionView = nil;
    }
    return self;
}

- (void)anchorOnTargetView:(id<CTDTargetRenderer>)targetView
{
    if (_anchorTargetView != targetView) {
        if (_anchorTargetView) {
            [_anchorTargetView hideSelectionIndicator];
        }
        _anchorTargetView = targetView;
        [targetView showSelectionIndicator];
        if (_connectionView) {
            // Anchor must always be set before free end, so we never need to
            // *create* the connection view here; just update it if it exists.
            [_connectionView setFirstEndpointPosition:[targetView connectionPoint]];
        }
    }
}

- (void)connectFreeEndToTargetView:(id<CTDTargetRenderer>)targetView
                  orMoveToPosition:(CTDPoint*)freeEndPosition
{
    NSAssert(_anchorTargetView,
             @"Connection must be anchored before free end can be moved.");

    if (_freeEndTargetView && (_freeEndTargetView == targetView)) {
        return;
    }

    if (_freeEndTargetView) {
        [_freeEndTargetView hideSelectionIndicator];
    }
    _freeEndTargetView = targetView;
    if (targetView) {
        [targetView showSelectionIndicator];
        // snap end of connection to target's connection point
        freeEndPosition = [targetView connectionPoint];
    }

    if (!_connectionView) {
        id<CTDTrialRenderer> trialRenderer = _trialRenderer;
        CTDPoint* anchorPosition = [_anchorTargetView connectionPoint];
        _connectionView = [trialRenderer
                           newTargetConnectionViewWithFirstEndpointPosition:anchorPosition
                           secondEndpointPosition:freeEndPosition];
    } else {
        [_connectionView setSecondEndpointPosition:freeEndPosition];
    }
}

- (void)cancelConnection
{
    [_connectionView invalidate];
    _connectionView = nil;
    [_anchorTargetView hideSelectionIndicator];
    [_freeEndTargetView hideSelectionIndicator];
}

@end
