// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDConnectionTouchInteraction.h"

#import "Ports/CTDTouchMappers.h"
#import "CTDApplication/CTDTrialStepEditor.h"
#import "CTDApplication/Ports/CTDTrialRenderer.h"
#import "CTDUtility/CTDPoint.h"



//typedef enum {
//    CTDConnectionInteractionPhaseNotYetActive,
//    CTDConnectionInteractionPhaseAnchored
////    CTDConnectionInteractionConnected
//} CTDConnectionInteractionPhase;





@implementation CTDConnectionTouchInteraction
{
    id<CTDTrialStepConnectionEditor> _connectionEditor;
    id<CTDTouchToElementMapper> _dotTouchMapper;
    id<CTDTouchToPointMapper> _freeEndMapper;
    id _startingDotId;
}



#pragma mark Initialization


- (instancetype)
      initWithConnectionEditor:(id<CTDTrialStepConnectionEditor>)connectionEditor
                dotTouchMapper:(id<CTDTouchToElementMapper>)dotTouchMapper
                 freeEndMapper:(id<CTDTouchToPointMapper>)freeEndMapper
                 startingDotId:(id)startingDotId
          initialTouchPosition:(CTDPoint*)initialPosition
{
    self = [super init];
    if (self)
    {
        if (!connectionEditor) {
            [NSException raise:NSInvalidArgumentException
                        format:@"Connection Editor must be supplied"];
        }
        _connectionEditor = connectionEditor;
        _dotTouchMapper = dotTouchMapper;
        _freeEndMapper = freeEndMapper;
        _startingDotId = startingDotId;

        [connectionEditor setFreeEndPosition:
            [freeEndMapper pointAtTouchLocation:initialPosition]];
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(CTDPoint*)newPosition
{
    id hitElement = [_dotTouchMapper elementAtTouchLocation:newPosition];
    if (hitElement && (hitElement != _startingDotId))
    {
        [_connectionEditor completeConnection];
    }
    else
    {
        CTDPoint* freeEndPosition = [_freeEndMapper pointAtTouchLocation:newPosition];
        if (freeEndPosition)
        {
            [_connectionEditor setFreeEndPosition:freeEndPosition];
        }
    }
}

- (void)touchDidEnd
{
    [self touchWasCancelled];
}

- (void)touchWasCancelled
{
    [_connectionEditor cancelConnection];
}

@end
