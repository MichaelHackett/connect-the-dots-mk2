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
}



#pragma mark Initialization


- (instancetype)
      initWithConnectionEditor:(id<CTDTrialStepConnectionEditor>)connectionEditor
                dotTouchMapper:(id<CTDTouchToElementMapper>)dotTouchMapper
                 freeEndMapper:(id<CTDTouchToPointMapper>)freeEndMapper
{
    self = [super init];
    if (self)
    {
        _connectionEditor = connectionEditor;
        _dotTouchMapper = dotTouchMapper;
        _freeEndMapper = freeEndMapper;
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD



#pragma mark CTDTouchTracker protocol


- (void)touchDidMoveTo:(__unused CTDPoint*)newPosition
{
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
