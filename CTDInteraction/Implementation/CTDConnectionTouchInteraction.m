// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDConnectionTouchInteraction.h"

#import "ExtensionPoints/CTDTouchMappers.h"
#import "CTDPresentation/CTDDotConnectionRenderer.h"
#import "CTDPresentation/CTDDotRenderer.h"
#import "CTDPresentation/CTDTrialRenderer.h"
#import "CTDUtility/CTDPoint.h"



//typedef enum {
//    CTDConnectionInteractionPhaseNotYetActive,
//    CTDConnectionInteractionPhaseAnchored
////    CTDConnectionInteractionConnected
//} CTDConnectionInteractionPhase;



@interface CTDConnectionPresenter : NSObject

- (instancetype)initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer;
- (void)anchorOnDotWithRenderer:(id<CTDDotRenderer>)dotRenderer;
- (void)connectFreeEndToDotWithRenderer:(id<CTDDotRenderer>)dotRenderer
                       orMoveToPosition:(CTDPoint*)freeEndPosition;
- (void)cancelConnection;

@end





@implementation CTDConnectionTouchInteraction
{
    id<CTDTouchToElementMapper> _dotTouchMapper;
    id<CTDTouchToPointMapper> _freeEndMapper;
    CTDConnectionPresenter* _presenter;
    id<CTDDotRenderer> _anchorDotRenderer;
}



#pragma mark Initialization


- (instancetype)
      initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer
             dotTouchMapper:(id<CTDTouchToElementMapper>)dotTouchMapper
              freeEndMapper:(id<CTDTouchToPointMapper>)freeEndMapper
          anchorDotRenderer:(id<CTDDotRenderer>)anchorDotRenderer
     initialFreeEndPosition:(CTDPoint*)initialFreeEndPosition
{
    self = [super init];
    if (self) {
        if (!anchorDotRenderer) {
            [NSException raise:NSInvalidArgumentException
                        format:@"Anchor dot renderer must not be nil"];
        }
        _dotTouchMapper = dotTouchMapper;
        _freeEndMapper = freeEndMapper;
        _presenter = [[CTDConnectionPresenter alloc]
                      initWithTrialRenderer:trialRenderer];

        _anchorDotRenderer = anchorDotRenderer;
        [_presenter anchorOnDotWithRenderer:_anchorDotRenderer];
        [_presenter connectFreeEndToDotWithRenderer:nil
                                   orMoveToPosition:initialFreeEndPosition];
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    id<CTDDotRenderer> connectedDotRenderer = nil;
    id hitElement = [_dotTouchMapper elementAtTouchLocation:newPosition];
    if (hitElement &&
        hitElement != _anchorDotRenderer &&
        [hitElement conformsToProtocol:@protocol(CTDDotRenderer)])
    {
        connectedDotRenderer = (id<CTDDotRenderer>)hitElement;
    }

    CTDPoint* freeEndLocation = [_freeEndMapper pointAtTouchLocation:newPosition];
    [_presenter connectFreeEndToDotWithRenderer:connectedDotRenderer
                               orMoveToPosition:freeEndLocation];
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
    id<CTDDotRenderer> _anchorDotRenderer;
    id<CTDDotRenderer> _freeEndDotRenderer;
    id<CTDDotConnectionRenderer> _connectionRenderer;
}

- (instancetype)initWithTrialRenderer:(id<CTDTrialRenderer>)trialRenderer
{
    self = [super init];
    if (self) {
        _trialRenderer = trialRenderer;
        _anchorDotRenderer = nil;
        _freeEndDotRenderer = nil;
        _connectionRenderer = nil;
    }
    return self;
}

- (void)anchorOnDotWithRenderer:(id<CTDDotRenderer>)dotRenderer
{
    if (_anchorDotRenderer != dotRenderer) {
        if (_anchorDotRenderer) {
            [_anchorDotRenderer hideSelectionIndicator];
        }
        _anchorDotRenderer = dotRenderer;
        [dotRenderer showSelectionIndicator];
        if (_connectionRenderer) {
            // Anchor must always be set before free end, so we never need to
            // *create* the connection renderer here; just update it if it exists.
            [_connectionRenderer setFirstEndpointPosition:[dotRenderer connectionPoint]];
        }
    }
}

- (void)connectFreeEndToDotWithRenderer:(id<CTDDotRenderer>)dotRenderer
                       orMoveToPosition:(CTDPoint*)freeEndPosition
{
    NSAssert(_anchorDotRenderer,
             @"Connection must be anchored before free end can be moved.");

    if (_freeEndDotRenderer && (_freeEndDotRenderer == dotRenderer)) {
        return;
    }

    if (_freeEndDotRenderer) {
        [_freeEndDotRenderer hideSelectionIndicator];
    }
    _freeEndDotRenderer = dotRenderer;
    if (dotRenderer) {
        [dotRenderer showSelectionIndicator];
        // snap end of connection to dot's connection point
        freeEndPosition = [dotRenderer connectionPoint];
    }

    if (!_connectionRenderer) {
        id<CTDTrialRenderer> trialRenderer = _trialRenderer;
        CTDPoint* anchorPosition = [_anchorDotRenderer connectionPoint];
        _connectionRenderer =
            [trialRenderer
             newDotConnectionRenderingWithFirstEndpointPosition:anchorPosition
             secondEndpointPosition:freeEndPosition];
    } else {
        [_connectionRenderer setSecondEndpointPosition:freeEndPosition];
    }
}

- (void)cancelConnection
{
    [_connectionRenderer invalidate];
    _connectionRenderer = nil;
    [_anchorDotRenderer hideSelectionIndicator];
    [_freeEndDotRenderer hideSelectionIndicator];
}

@end
