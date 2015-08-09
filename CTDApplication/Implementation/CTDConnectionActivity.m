// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDConnectionActivity.h"

#import "CTDColorMapping.h"
#import "Ports/CTDTrialRenderer.h"

#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDTrial.h"
#import "CTDUtility/CTDPoint.h"



@protocol CTDDotConnection <NSObject>
- (void)invalidate;
@end

@protocol CTDDotConnectionStateObserver <NSObject>
- (void)connectionEnded;
@end




@interface CTDConnectionActivityDotConnection : NSObject <CTDDotConnection>

- (instancetype)initWithConnectionRenderer:(id<CTDDotConnectionRenderer>)connectionRenderer
                   connectionStateObserver:(id<CTDDotConnectionStateObserver>)connectionStateObserver;
CTD_NO_DEFAULT_INIT

@end


@interface CTDConnectionActivityDotConnectionEditor : NSObject <CTDTrialStepConnectionEditor>

- (instancetype)initWithDotConnection:(CTDConnectionActivityDotConnection*)dotConnection;
CTD_NO_DEFAULT_INIT

@end


@interface CTDConnectionActivityTrialStepEditor : NSObject <CTDTrialStepEditor,
                                                            CTDDotConnectionStateObserver>

- (instancetype)initWithStartingDotRenderer:(id<CTDDotRenderer>)startingDotRenderer
                          endingDotRenderer:(id<CTDDotRenderer>)endingDotRenderer
                         connectionRenderer:(id<CTDDotConnectionRenderer>)connectionRenderer;

@end



@implementation CTDConnectionActivity
{
    id<CTDTrial> _trial;
    id<CTDTrialRenderer> _trialRenderer;
    id<CTDTrialStepEditor> _trialStepEditor;
}

- (instancetype)initWithTrial:(id<CTDTrial>)trial
                trialRenderer:(id<CTDTrialRenderer>)trialRenderer
{
    self = [super init];
    if (self)
    {
        _trial = trial;
        _trialRenderer = trialRenderer;
        _trialStepEditor = nil;
    }
    return self;
}

- (void)beginTrial
{
    CTDDotPair* firstStep = [_trial dotPairs][0];

    id<CTDDotRenderer> startingDotRenderer = [_trialRenderer newRendererForDot];
    [startingDotRenderer setDotCenterPosition:firstStep.startPosition];
    [startingDotRenderer setDotColor:paletteColorForDotColor(firstStep.color)];

    id<CTDDotRenderer> endingDotRenderer = [_trialRenderer newRendererForDot];
    [endingDotRenderer setDotCenterPosition:firstStep.endPosition];
    [endingDotRenderer setDotColor:paletteColorForDotColor(firstStep.color)];

    id<CTDDotConnectionRenderer> connectionRenderer =
        [_trialRenderer newRendererForDotConnection];
    [connectionRenderer setFirstEndpointPosition:[startingDotRenderer dotConnectionPoint]];

    [startingDotRenderer setVisible:YES];
    [endingDotRenderer setVisible:NO];
    [connectionRenderer setVisible:NO];

    _trialStepEditor = [[CTDConnectionActivityTrialStepEditor alloc]
                        initWithStartingDotRenderer:startingDotRenderer
                                  endingDotRenderer:endingDotRenderer
                                 connectionRenderer:connectionRenderer];
}

@end



@implementation CTDConnectionActivityTrialStepEditor
{
    id<CTDDotRenderer> _startingDotRenderer;
    id<CTDDotRenderer> _endingDotRenderer;
    id<CTDDotConnectionRenderer> _connectionRenderer;
}

- (instancetype)initWithStartingDotRenderer:(id<CTDDotRenderer>)startingDotRenderer
                          endingDotRenderer:(id<CTDDotRenderer>)endingDotRenderer
                         connectionRenderer:(id<CTDDotConnectionRenderer>)connectionRenderer
{
    self = [super init];
    if (self) {
        _startingDotRenderer = startingDotRenderer;
        _endingDotRenderer = endingDotRenderer;
        _connectionRenderer = connectionRenderer;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD;



- (void)beginStep
{
    [_startingDotRenderer setVisible:YES];
    [_endingDotRenderer setVisible:NO];
    [_connectionRenderer setVisible:NO];
}

- (id<CTDDotConnection>)newConnection
{
    // TODO: Discard any previous dotConnection so we don't have two things
    // using the same renderer!

    id<CTDDotConnection> dotConnection = [[CTDConnectionActivityDotConnection alloc]
                                          initWithConnectionRenderer:_connectionRenderer
                                             connectionStateObserver:self];
    [_connectionRenderer setSecondEndpointPosition:[_startingDotRenderer dotConnectionPoint]];

    [_startingDotRenderer showSelectionIndicator];
    [_endingDotRenderer setVisible:YES];
    [_connectionRenderer setVisible:YES];

    return dotConnection;
}



#pragma mark CTDTrialStepEditor protocol

- (id<CTDTrialStepConnectionEditor>)editorForNewConnection
{
    return [[CTDConnectionActivityDotConnectionEditor alloc]
            initWithDotConnection:[self newConnection]];
}



#pragma mark CTDDotConnectionStateObserver protocol


- (void)connectionEnded
{
    [_startingDotRenderer hideSelectionIndicator];
    [_endingDotRenderer setVisible:NO];
    [_connectionRenderer setVisible:NO];
}

@end



@implementation CTDConnectionActivityDotConnection
{
    id<CTDDotConnectionRenderer> _renderer;
    __weak id<CTDDotConnectionStateObserver> _connectionStateObserver;
}

- (instancetype)initWithConnectionRenderer:(id<CTDDotConnectionRenderer>)connectionRenderer
                   connectionStateObserver:(id<CTDDotConnectionStateObserver>)connectionStateObserver
{
    self = [super init];
    if (self)
    {
        _renderer = connectionRenderer;
        _connectionStateObserver = connectionStateObserver;
    }
    return self;
}

- (void)invalidate
{
//    [_renderer discardRendering];
    _renderer = nil;

    id<CTDDotConnectionStateObserver> connectionStateObserver = _connectionStateObserver;
    [connectionStateObserver connectionEnded];
    _connectionStateObserver = nil;  // send no further updates
}

@end



@implementation CTDConnectionActivityDotConnectionEditor
{
    CTDConnectionActivityDotConnection* _dotConnection;
}

- (instancetype)initWithDotConnection:(CTDConnectionActivityDotConnection*)dotConnection
{
    self = [super init];
    if (self)
    {
        _dotConnection = dotConnection;
    }
    return self;
}

- (void)cancelConnection
{
    [_dotConnection invalidate];
}

@end
