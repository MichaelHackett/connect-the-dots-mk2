// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDConnectionActivity.h"

#import "CTDColorMapping.h"
#import "Ports/CTDColorCellRenderer.h"
#import "Ports/CTDTimeSource.h"
#import "Ports/CTDTrialRenderer.h"

#import "CTDInteraction/Ports/CTDSelectionEditor.h"
#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDTrialResults.h"
#import "CTDModel/CTDTrialScript.h"
#import "CTDUtility/CTDNotificationReceiver.h"
#import "CTDUtility/CTDPoint.h"



// Notification definitions
NSString * const CTDTrialCompletedNotification = @"CTDTrialCompletedNotification";



@protocol CTDColorSelectionObserver <NSObject>
- (void)selectedColorChangedTo:(CTDDotColor)newColor;
@end

@protocol CTDDotConnectionStateObserver <NSObject>
// Only one of these two messages will be sent and it will be sent only once.
- (void)connectionCompleted;
- (void)connectionCancelled;
@end

@protocol CTDTrialStepStateObserver <NSObject>
- (void)trialStepCompleted;
@end



@protocol CTDTrialStep <NSObject>

- (CTDDotColor)dotPairColor;

- (id<CTDDotConnection>)newConnection;

// Remove user interface and prepare to be deallocated. --- NEEDED?
- (void)invalidate;

@end




@interface CTDConnectionActivityDotConnection : NSObject <CTDDotConnection>

- (instancetype)initWithConnectionRenderer:(id<CTDDotConnectionRenderer>)connectionRenderer
                   connectionStateObserver:(id<CTDDotConnectionStateObserver>)connectionStateObserver
                         targetDotRenderer:(id<CTDDotRenderer>)targetDotRenderer;
CTD_NO_DEFAULT_INIT

@end


@interface CTDConnectionActivityDotConnectionEditor : NSObject <CTDTrialStepConnectionEditor>

- (instancetype)initWithDotConnection:(CTDConnectionActivityDotConnection*)dotConnection;
CTD_NO_DEFAULT_INIT

@end


@interface CTDConnectionActivityTrialStep : NSObject <CTDTrialStep,
                                                      CTDDotConnectionStateObserver>

// TODO: Move to separate factory class (as instance method)?
+ (instancetype)trialStepWithDotPairColor:(CTDDotColor)dotPairColor
                      startingDotPosition:(CTDPoint*)startingDotPosition
                        endingDotPosition:(CTDPoint*)endingDotPosition
                            trialRenderer:(id<CTDTrialRenderer>)trialRenderer
                   trialStepStateObserver:(id<CTDTrialStepStateObserver>)trialStepStateObserver;

// Transfers ownership of dot and connection renderers. Observer held weakly.
- (instancetype)initWithDotPairColor:(CTDDotColor)dotPairColor
                 startingDotRenderer:(id<CTDDotRenderer>)startingDotRenderer
                   endingDotRenderer:(id<CTDDotRenderer>)endingDotRenderer
                  connectionRenderer:(id<CTDDotConnectionRenderer>)connectionRenderer
              trialStepStateObserver:(id<CTDTrialStepStateObserver>)trialStepStateObserver;

CTD_NO_DEFAULT_INIT

@end


@interface CTDColorSelectionCell : NSObject

@property (assign, nonatomic, getter=isSelected) BOOL selected;

- (void)incrementHighlightCount;
- (void)decrementHighlightCount;

@end


@interface CTDColorPicker : NSObject

@property (assign, nonatomic) CTDDotColor selectedColor;

- (instancetype)initWithColorCellRenderers:(NSDictionary*)colorCellRenderers
                    colorSelectionObserver:(id<CTDColorSelectionObserver>)colorSelectionObserver;
CTD_NO_DEFAULT_INIT

- (id<CTDSelectionRenderer>)editorForColorSelection;

@end


typedef void (^CTDColorSelectionSetter)(CTDDotColor);
typedef void (^CTDColorHighlightSetter)(CTDDotColor);

@interface CTDColorSelectionEditor : NSObject <CTDSelectionEditor>

- (instancetype)initWithSelectionSetter:(CTDColorSelectionSetter)selectionSetter
                        highlightSetter:(CTDColorHighlightSetter)highlightSetter;
CTD_NO_DEFAULT_INIT

@end





//
// Conversion between model colors and display element IDs.
//
static CTDDotColor dotColorFromCellId(id colorCellId)
{
    NSUInteger cellIndex = [colorCellId unsignedIntegerValue] - CTDColorCellIdMin;
    return CTDDotColor_Red + cellIndex;
}

//static id colorCellIdFromDotColor(CTDDotColor dotColor)
//{
//    NSUInteger cellIndex = dotColor - CTDDotColor_Red;
//    return @(CTDColorCellIdMin + cellIndex);
//}




@interface CTDConnectionActivity () <CTDTrialStepEditor,
                                     CTDTrialStepStateObserver,
                                     CTDColorSelectionObserver>
@end



@implementation CTDConnectionActivity
{
    // Inputs:
    id<CTDTrialScript> _trialScript;
    __weak id<CTDTrialResults> _trialResults;
    __weak id<CTDTimeSource> _timeSource;
    __weak id<CTDNotificationReceiver> _notificationReceiver;

    // Activity Model and internal helpers
    CTDColorPicker* _colorPicker;
    id<CTDTrialStep> _trialStep;
    CTDPoint* _startingDotRenderedPosition;
    CTDPoint* _endingDotRenderedPosition;
    double _stepStartTime;
    NSUInteger _stepIndex;

    void (^_startNextStep)(void);
}

- (instancetype)initWithTrialScript:(id<CTDTrialScript>)trialScript
                 trialResultsHolder:(id<CTDTrialResults>)trialResultsHolder
                      trialRenderer:(id<CTDTrialRenderer>)trialRenderer
                 colorCellRenderers:(NSDictionary*)colorCellRenderers
                         timeSource:(id<CTDTimeSource>)timeSource
trialCompletionNotificationReceiver:(id<CTDNotificationReceiver>)notificationReceiver
{
    self = [super init];
    if (self)
    {
        _trialScript = trialScript;
        _trialResults = trialResultsHolder;
        _timeSource = timeSource;
        _notificationReceiver = notificationReceiver;
        _colorPicker = [[CTDColorPicker alloc]
                        initWithColorCellRenderers:colorCellRenderers
                            colorSelectionObserver:self];
        _trialStep = nil;
        _stepStartTime = 0.0;
        _stepIndex = NSUIntegerMax;

        // Shared private code for starting a new trial step.
        ctd_weakify(self, weakSelf);
        ctd_weakify(trialRenderer, weakTrialRenderer);  // Q: does this need to be weak?
        _startNextStep = ^{
            ctd_strongify(weakSelf, strongSelf);
            ctd_strongify(weakTrialRenderer, strongTrialRenderer);
            CTDDotPair* stepDotPair =
                [strongSelf->_trialScript dotPairs][strongSelf->_stepIndex];
            strongSelf->_startingDotRenderedPosition = [trialRenderer
                renderingCoordinatesForDotSpaceCoordinates:stepDotPair.startPosition];
            strongSelf->_endingDotRenderedPosition = [trialRenderer
                renderingCoordinatesForDotSpaceCoordinates:stepDotPair.endPosition];
            strongSelf->_trialStep = [CTDConnectionActivityTrialStep
                                      trialStepWithDotPairColor:stepDotPair.color
                                      startingDotPosition:strongSelf->_startingDotRenderedPosition
                                      endingDotPosition:strongSelf->_endingDotRenderedPosition
                                      trialRenderer:strongTrialRenderer
                                      trialStepStateObserver:strongSelf];

            // Start step timer.
            ctd_strongify(strongSelf->_timeSource, strongTimeSource);
            strongSelf->_stepStartTime = [strongTimeSource systemTime];
        };
    }
    return self;
}



#pragma mark CTDTrial protocol


- (void)selectColor:(CTDDotColor)color
{
    _colorPicker.selectedColor = color;
}



#pragma mark CTDTrialEditor protocol


- (void)beginTrial
{
    _stepIndex = 0;
    _startNextStep();
}

- (void)advanceToNextStep
{
    // Calculate length of time required to complete step; store it in the results.
    ctd_strongify(_timeSource, timeSource);
    ctd_strongify(_trialResults, trialResults);
    double stepEndTime = [timeSource systemTime];
    NSTimeInterval stepDuration = (NSTimeInterval)(stepEndTime - _stepStartTime);

    [trialResults setDuration:stepDuration
                forStepNumber:_stepIndex + 1
          startingDotPosition:_startingDotRenderedPosition
            endingDotPosition:_endingDotRenderedPosition];

    [_trialStep invalidate];
    _trialStep = nil;

    _stepIndex += 1;
    if (_stepIndex >= [[_trialScript dotPairs] count])
    {
        ctd_strongify(_notificationReceiver, notificationReceiver);
        [notificationReceiver receiveNotification:CTDTrialCompletedNotification
                                       fromSender:self
                                         withInfo:nil];
    }
    else
    {
        _startNextStep();
    }
}

- (id<CTDTrialStepEditor>)editorForCurrentStep
{
    return self;
}

- (id<CTDSelectionRenderer>)editorForColorSelection
{
    return [_colorPicker editorForColorSelection];
}



#pragma mark CTDTrialStepEditor protocol


- (BOOL)isConnectionAllowed
{
    return [_colorPicker selectedColor] == [_trialStep dotPairColor];
}

- (id<CTDTrialStepConnectionEditor>)editorForNewConnection
{
    if (![self isConnectionAllowed]) { return nil; }
    return [[CTDConnectionActivityDotConnectionEditor alloc]
            initWithDotConnection:[_trialStep newConnection]];
}

- (id)startingDotId
{
    return @1;
}

- (id)endingDotId
{
    return @2;
}



#pragma mark CTDTrialStepStateObserver protocol

- (void)trialStepCompleted
{
    [self advanceToNextStep];
}


#pragma mark CTDColorSelectionObserver protocol

- (void)selectedColorChangedTo:(__unused CTDDotColor)newColor
{
    // TODO: May want to replace ColorPicker's getter with a locally-stored
    // copy of the value here, and may want to notify any active Interactors,
    // so that a connection could start if a touch is already on a target dot.
}

@end




@implementation CTDConnectionActivityTrialStep
{
    CTDDotColor _dotPairColor;
    id<CTDDotRenderer> _startingDotRenderer;
    id<CTDDotRenderer> _endingDotRenderer;
    id<CTDDotConnectionRenderer> _connectionRenderer;
    __weak id<CTDTrialStepStateObserver> _trialStepStateObserver;
}

+ (instancetype)trialStepWithDotPairColor:(CTDDotColor)dotPairColor
                      startingDotPosition:(CTDPoint*)startingDotPosition
                        endingDotPosition:(CTDPoint*)endingDotPosition
                            trialRenderer:(id<CTDTrialRenderer>)trialRenderer
                   trialStepStateObserver:(id<CTDTrialStepStateObserver>)trialStepStateObserver
{
    id<CTDDotRenderer> startingDotRenderer = [trialRenderer newRendererForDotWithId:@1];
    [startingDotRenderer setDotCenterPosition:startingDotPosition];
    [startingDotRenderer setDotColor:paletteColorForDotColor(dotPairColor)];

    id<CTDDotRenderer> endingDotRenderer = [trialRenderer newRendererForDotWithId:@2];
    [endingDotRenderer setDotCenterPosition:endingDotPosition];
    [endingDotRenderer setDotColor:paletteColorForDotColor(dotPairColor)];

    id<CTDDotConnectionRenderer> connectionRenderer = [trialRenderer newRendererForDotConnection];
    [connectionRenderer setFirstEndpointPosition:[startingDotRenderer dotConnectionPoint]];

    [startingDotRenderer setVisible:YES];
    [endingDotRenderer setVisible:NO];
    [connectionRenderer setVisible:NO];
    
    return [[self alloc] initWithDotPairColor:dotPairColor
                          startingDotRenderer:startingDotRenderer
                            endingDotRenderer:endingDotRenderer
                           connectionRenderer:connectionRenderer
                       trialStepStateObserver:trialStepStateObserver];
}

- (instancetype)initWithDotPairColor:(CTDDotColor)dotPairColor
                 startingDotRenderer:(id<CTDDotRenderer>)startingDotRenderer
                   endingDotRenderer:(id<CTDDotRenderer>)endingDotRenderer
                  connectionRenderer:(id<CTDDotConnectionRenderer>)connectionRenderer
              trialStepStateObserver:(id<CTDTrialStepStateObserver>)trialStepStateObserver
{
    self = [super init];
    if (self) {
        _dotPairColor = dotPairColor;
        _startingDotRenderer = startingDotRenderer;
        _endingDotRenderer = endingDotRenderer;
        _connectionRenderer = connectionRenderer;
        _trialStepStateObserver = trialStepStateObserver;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD;



#pragma mark - CTDTrialStep protocol


- (CTDDotColor)dotPairColor
{
    return _dotPairColor;
}

- (id<CTDDotConnection>)newConnection
{
    // TODO: Discard any previous dotConnection so we don't have two things using the same renderer!

    id<CTDDotConnection> dotConnection = [[CTDConnectionActivityDotConnection alloc]
                                          initWithConnectionRenderer:_connectionRenderer
                                             connectionStateObserver:self
                                                   targetDotRenderer:_endingDotRenderer];
    [_connectionRenderer setSecondEndpointPosition:[_startingDotRenderer dotConnectionPoint]];

    [_startingDotRenderer showSelectionIndicator];
    [_endingDotRenderer setVisible:YES];
    [_connectionRenderer setVisible:YES];

    return dotConnection;
}

- (void)invalidate
{
    [_startingDotRenderer discardRendering];
    _startingDotRenderer = nil;
    [_endingDotRenderer discardRendering];
    _endingDotRenderer = nil;
    [_connectionRenderer discardRendering];
    _connectionRenderer = nil;
}



#pragma mark CTDDotConnectionStateObserver protocol


- (void)connectionCompleted
{
    [self connectionCancelled];
    [_startingDotRenderer hideSelectionIndicator];
    [_startingDotRenderer setVisible:NO];

    ctd_strongify(_trialStepStateObserver, trialStepStateObserver);
    [trialStepStateObserver trialStepCompleted];
}

- (void)connectionCancelled
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
    __weak id<CTDDotRenderer> _targetDotRenderer;
    BOOL _connectionEstablished;
}

- (instancetype)initWithConnectionRenderer:(id<CTDDotConnectionRenderer>)connectionRenderer
                   connectionStateObserver:(id<CTDDotConnectionStateObserver>)connectionStateObserver
                         targetDotRenderer:(id<CTDDotRenderer>)targetDotRenderer
{
    self = [super init];
    if (self)
    {
        _renderer = connectionRenderer;
        _connectionStateObserver = connectionStateObserver;
        _targetDotRenderer = targetDotRenderer;
        _connectionEstablished = NO;
    }
    return self;
}

- (void)setFreeEndPosition:(CTDPoint*)freeEndPosition
{
    if (_connectionEstablished)
    {
        _connectionEstablished = NO;
        id<CTDDotRenderer> targetDotRenderer = _targetDotRenderer;
        [targetDotRenderer hideSelectionIndicator];
    }
    [_renderer setSecondEndpointPosition:freeEndPosition];
}

- (void)establishConnection
{
    if (!_connectionEstablished)
    {
        _connectionEstablished = YES;
        id<CTDDotRenderer> targetDotRenderer = _targetDotRenderer;
        [_renderer setSecondEndpointPosition:[targetDotRenderer dotConnectionPoint]];
        [targetDotRenderer showSelectionIndicator];
    }
}

- (void)commitConnectionState
{
//    [_renderer discardRendering];
    _renderer = nil;

    id<CTDDotRenderer> targetDotRenderer = _targetDotRenderer;
    [targetDotRenderer hideSelectionIndicator];

    ctd_strongify(_connectionStateObserver, connectionStateObserver);
    if (_connectionEstablished)
    {
        [connectionStateObserver connectionCompleted];
    }
    else
    {
        [connectionStateObserver connectionCancelled];
    }
    _connectionStateObserver = nil;  // send no further updates
}

- (void)invalidate
{
    _connectionEstablished = NO;
    [self commitConnectionState];
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

- (void)setFreeEndPosition:(CTDPoint*)freeEndPosition
{
    [_dotConnection setFreeEndPosition:freeEndPosition];
}

- (void)establishConnection
{
    [_dotConnection establishConnection];
}

- (void)commitConnectionState
{
    [_dotConnection commitConnectionState];
}

- (void)cancelConnection
{
    [_dotConnection invalidate];
}

@end




@implementation CTDColorSelectionCell
{
    __weak id<CTDColorCellRenderer> _renderer;
    NSUInteger _highlightCount;
}

- (id)initWithRenderer:(id<CTDColorCellRenderer>)renderer
{
    self = [super init];
    if (self)
    {
        _renderer = renderer;
        _highlightCount = 0;
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    ctd_strongify(_renderer, renderer);
    if (selected)
    {
        [renderer showSelectionIndicator];
    }
    else
    {
        [renderer hideSelectionIndicator];
    }
}

- (void)incrementHighlightCount
{
    if (_highlightCount == 0)
    {
        ctd_strongify(_renderer, renderer);
        [renderer showHighlightIndicator];
    }
    _highlightCount += 1;
}

- (void)decrementHighlightCount
{
    _highlightCount -= 1;
    if (_highlightCount == 0)
    {
        ctd_strongify(_renderer, renderer);
        [renderer hideHighlightIndicator];
    }
}

@end




@implementation CTDColorPicker
{
    NSDictionary* _colorCells;
    __weak id<CTDColorSelectionObserver> _colorSelectionObserver;
}

- (instancetype)initWithColorCellRenderers:(NSDictionary*)colorCellRenderers
                colorSelectionObserver:(id<CTDColorSelectionObserver>)colorSelectionObserver
{
    self = [super init];
    if (self)
    {
        NSMutableDictionary* colorCells =
            [NSMutableDictionary dictionaryWithCapacity:[colorCellRenderers count]];
        [colorCellRenderers enumerateKeysAndObjectsUsingBlock:
            ^(id cellId, id<CTDColorCellRenderer> cellRenderer, __unused BOOL* stop)
        {
            CTDColorSelectionCell* cell = [[CTDColorSelectionCell alloc]
                                           initWithRenderer:cellRenderer];
            [colorCells setObject:cell forKey:@(dotColorFromCellId(cellId))];
        }];

        _colorCells = [colorCells copy];
        _colorSelectionObserver = colorSelectionObserver;
        _selectedColor = CTDDotColor_None;
        [colorSelectionObserver selectedColorChangedTo:_selectedColor];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD


- (void)setSelectedColor:(CTDDotColor)selectedColor
{
    if (selectedColor == _selectedColor) { return; }

    if (_selectedColor != CTDDotColor_None)
    {
        [_colorCells[@(_selectedColor)] setSelected:NO];
    }
    if (selectedColor != CTDDotColor_None)
    {
        [_colorCells[@(selectedColor)] setSelected:YES];
    }
    _selectedColor = selectedColor;

    ctd_strongify(_colorSelectionObserver, colorSelectionObserver);
    [colorSelectionObserver selectedColorChangedTo:selectedColor];
}

- (id<CTDSelectionEditor>)editorForColorSelection
{
    CTDColorSelectionSetter selectionSetter = ^(CTDDotColor selectedColor)
    {
        // TODO: Handle contention between multiple simultaneous editors.
        self.selectedColor = selectedColor;
    };

    __block CTDDotColor previouslyHighlightedColor = CTDDotColor_None;

    CTDColorHighlightSetter highlightSetter = ^(CTDDotColor highlightedColor)
    {
        if (highlightedColor == previouslyHighlightedColor) { return; }

        if (previouslyHighlightedColor != CTDDotColor_None)
        {
            [self->_colorCells[@(previouslyHighlightedColor)] decrementHighlightCount];
        }
        if (highlightedColor != CTDDotColor_None)
        {
            [self->_colorCells[@(highlightedColor)] incrementHighlightCount];
        }
        previouslyHighlightedColor = highlightedColor;

    };

    return [[CTDColorSelectionEditor alloc]
            initWithSelectionSetter:selectionSetter
                    highlightSetter:highlightSetter];
}

@end




@implementation CTDColorSelectionEditor
{
    CTDColorSelectionSetter _selectionSetter;
    CTDColorHighlightSetter _highlightSetter;
}

- (instancetype)initWithSelectionSetter:(CTDColorSelectionSetter)selectionSetter
                        highlightSetter:(CTDColorHighlightSetter)highlightSetter
{
    self = [super init];
    if (self)
    {
        _selectionSetter = [selectionSetter copy];
        _highlightSetter = [highlightSetter copy];
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD


- (void)highlightElementWithId:(id)elementId
{
    _highlightSetter(dotColorFromCellId(elementId));
}

- (void)clearHighlighting
{
    _highlightSetter(CTDDotColor_None);
}

- (void)selectElementWithId:(id)elementId
{
    _selectionSetter(dotColorFromCellId(elementId));
}

- (void)clearSelection
{
    _selectionSetter(CTDDotColor_None);
}

@end
