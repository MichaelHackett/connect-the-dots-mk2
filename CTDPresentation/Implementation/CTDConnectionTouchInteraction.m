// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDConnectionTouchInteraction.h"

#import "CTDTargetConnectionView.h"
#import "CTDTargetContainerView.h"
#import "CTDTargetView.h"
#import "CTDTouchMapper.h"
#import "CTDUtility/CTDPoint.h"



//typedef enum {
//    CTDConnectionInteractionPhaseNotYetActive,
//    CTDConnectionInteractionPhaseAnchored
////    CTDConnectionInteractionConnected
//} CTDConnectionInteractionPhase;



@interface CTDConnectionPresenter : NSObject

- (instancetype)initWithTargetContainerView:(id<CTDTargetContainerView>)targetContainerView;
- (void)anchorOnTargetView:(id<CTDTargetView>)targetView;
- (void)connectFreeEndToTargetView:(id<CTDTargetView>)targetView
                  orMoveToPosition:(CTDPoint*)freeEndPosition;
- (void)cancelConnection;

@end





@implementation CTDConnectionTouchInteraction
{
    id<CTDTouchMapper> _targetTouchMapper;
    CTDConnectionPresenter* _presenter;
    id<CTDTargetView> _anchorTargetView;
}



#pragma mark - Initialization


- (instancetype)
      initWithTargetContainerView:(id<CTDTargetContainerView>)targetContainerView
                targetTouchMapper:(id<CTDTouchMapper>)targetTouchMapper
             initialTouchPosition:(CTDPoint*)initialPosition
{
    self = [super init];
    if (self) {
        _targetTouchMapper = targetTouchMapper;
        _presenter = [[CTDConnectionPresenter alloc]
                      initWithTargetContainerView:targetContainerView];

        _anchorTargetView = [targetTouchMapper elementAtTouchLocation:initialPosition];
        if (_anchorTargetView) {
            [_presenter anchorOnTargetView:_anchorTargetView];
        }
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD



#pragma mark - CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    id hitElement = [_targetTouchMapper elementAtTouchLocation:newPosition];
    if (!_anchorTargetView &&
        hitElement &&
        [hitElement conformsToProtocol:@protocol(CTDTargetView)])
    {
        _anchorTargetView = hitElement;
        [_presenter anchorOnTargetView:_anchorTargetView];
    }
    if (_anchorTargetView) {
        if (hitElement == _anchorTargetView) {
            hitElement = nil; // cannot connect back to same target
        }
        [_presenter connectFreeEndToTargetView:hitElement
                              orMoveToPosition:newPosition];
    }
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
    __weak id<CTDTargetContainerView> _targetContainerView;
    id<CTDTargetView> _anchorTargetView;
    id<CTDTargetView> _freeEndTargetView;
    id<CTDTargetConnectionView> _connectionView;
}

- (instancetype)initWithTargetContainerView:(id<CTDTargetContainerView>)targetContainerView
{
    self = [super init];
    if (self) {
        _targetContainerView = targetContainerView;
        _anchorTargetView = nil;
        _connectionView = nil;
    }
    return self;
}

- (void)anchorOnTargetView:(id<CTDTargetView>)targetView
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

- (void)connectFreeEndToTargetView:(id<CTDTargetView>)targetView
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
        id<CTDTargetContainerView> targetContainerView = _targetContainerView;
        CTDPoint* anchorPosition = [_anchorTargetView connectionPoint];
        _connectionView = [targetContainerView
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
