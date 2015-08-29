// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDConnectionActivity.h"

#import "CTDColorMapping.h"
#import "Ports/CTDColorCellRenderer.h"
#import "Ports/CTDTrialRenderer.h"

#import "CTDInteraction/Ports/CTDSelectionEditor.h"
#import "CTDModel/CTDDotPair.h"
#import "CTDModel/CTDTrialScript.h"
#import "CTDUtility/CTDNotificationReceiver.h"
#import "CTDUtility/CTDPoint.h"



// Notification definitions
NSString * const CTDTrialCompletedNotification = @"CTDTrialCompletedNotification";



@protocol CTDDotConnection <NSObject>

- (void)setFreeEndPosition:(CTDPoint*)freeEndPosition;
- (void)establishConnection;
- (void)invalidate;

@end


@protocol CTDDotConnectionStateObserver <NSObject>
// Only one of these two messages will be sent and it will be sent only once.
- (void)connectionCompleted;
- (void)connectionCancelled;
@end

@protocol CTDTrialStepStateObserver <NSObject>
- (void)trialStepCompleted;
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


@interface CTDConnectionActivityTrialStepEditor : NSObject <CTDTrialStepEditor,
                                                            CTDDotConnectionStateObserver>

// TODO: Move to separate factory class (as instance method)?
+ (instancetype)trialStepEditorWithDotPair:(CTDDotPair*)dotPair
                             trialRenderer:(id<CTDTrialRenderer>)trialRenderer
                    trialStepStateObserver:(id<CTDTrialStepStateObserver>)trialStepStateObserver;

// Transfers ownership of dot and connection renderers. Weak ref to given observer.
- (instancetype)initWithStartingDotRenderer:(id<CTDDotRenderer>)startingDotRenderer
                          endingDotRenderer:(id<CTDDotRenderer>)endingDotRenderer
                         connectionRenderer:(id<CTDDotConnectionRenderer>)connectionRenderer
                     trialStepStateObserver:(id<CTDTrialStepStateObserver>)trialStepStateObserver;

@end


@interface CTDColorSelectionCell : NSObject

@property (assign, nonatomic, getter=isSelected) BOOL selected;

- (void)incrementHighlightCount;
- (void)decrementHighlightCount;

@end


@interface CTDColorPicker : NSObject

@property (assign, readonly, nonatomic) CTDDotColor selectedColor;

- (instancetype)initWithColorCellRenderers:(NSDictionary*)colorCellRenderers;
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




@interface CTDConnectionActivity () <CTDTrialStepStateObserver>
@end



@implementation CTDConnectionActivity
{
    id<CTDTrialScript> _trialScript;
    id<CTDTrialRenderer> _trialRenderer;
    __weak id<CTDNotificationReceiver> _notificationReceiver;
    id<CTDTrialStepEditor> _trialStepEditor;
    CTDColorPicker* _colorPicker;
    NSUInteger _stepIndex;
}

- (instancetype)initWithTrialScript:(id<CTDTrialScript>)trialScript
                trialRenderer:(id<CTDTrialRenderer>)trialRenderer
                colorCellRenderers:(NSDictionary*)colorCellRenderers
                trialCompletionNotificationReceiver:(id<CTDNotificationReceiver>)notificationReceiver
{
    self = [super init];
    if (self)
    {
        _trialScript = trialScript;
        _trialRenderer = trialRenderer;
        _notificationReceiver = notificationReceiver;
        _trialStepEditor = nil;
        _colorPicker = [[CTDColorPicker alloc]
                        initWithColorCellRenderers:colorCellRenderers];
        _stepIndex = NSUIntegerMax;
    }
    return self;
}



#pragma mark CTDTrialEditor protocol


- (void)beginTrial
{
    _stepIndex = 0;
    _trialStepEditor = [CTDConnectionActivityTrialStepEditor
                        trialStepEditorWithDotPair:[_trialScript dotPairs][0]
                                     trialRenderer:_trialRenderer
                            trialStepStateObserver:self];
}

- (void)advanceToNextStep
{
    [_trialStepEditor invalidate];
    _trialStepEditor = nil;

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
        _trialStepEditor = [CTDConnectionActivityTrialStepEditor
                            trialStepEditorWithDotPair:[_trialScript dotPairs][_stepIndex]
                                         trialRenderer:_trialRenderer
                                trialStepStateObserver:self];
    }
}

- (id<CTDTrialStepEditor>)editorForCurrentStep
{
    return _trialStepEditor;
}

- (id<CTDSelectionRenderer>)editorForColorSelection
{
    return [_colorPicker editorForColorSelection];
}



#pragma mark CTDTrialStepStateObserver protocol


- (void)trialStepCompleted
{
    [self advanceToNextStep];
}

@end



@implementation CTDConnectionActivityTrialStepEditor
{
    id<CTDDotRenderer> _startingDotRenderer;
    id<CTDDotRenderer> _endingDotRenderer;
    id<CTDDotConnectionRenderer> _connectionRenderer;
    __weak id<CTDTrialStepStateObserver> _trialStepStateObserver;
}

+ (instancetype)trialStepEditorWithDotPair:(CTDDotPair*)dotPair
                             trialRenderer:(id<CTDTrialRenderer>)trialRenderer
                    trialStepStateObserver:(id<CTDTrialStepStateObserver>)trialStepStateObserver
{
    id<CTDDotRenderer> startingDotRenderer = [trialRenderer newRendererForDotWithId:@1];
    [startingDotRenderer setDotCenterPosition:dotPair.startPosition];
    [startingDotRenderer setDotColor:paletteColorForDotColor(dotPair.color)];

    id<CTDDotRenderer> endingDotRenderer = [trialRenderer newRendererForDotWithId:@2];
    [endingDotRenderer setDotCenterPosition:dotPair.endPosition];
    [endingDotRenderer setDotColor:paletteColorForDotColor(dotPair.color)];

    id<CTDDotConnectionRenderer> connectionRenderer = [trialRenderer newRendererForDotConnection];
    [connectionRenderer setFirstEndpointPosition:[startingDotRenderer dotConnectionPoint]];

    [startingDotRenderer setVisible:YES];
    [endingDotRenderer setVisible:NO];
    [connectionRenderer setVisible:NO];
    
    return [[CTDConnectionActivityTrialStepEditor alloc]
            initWithStartingDotRenderer:startingDotRenderer
                      endingDotRenderer:endingDotRenderer
                     connectionRenderer:connectionRenderer
                 trialStepStateObserver:trialStepStateObserver];
}

- (instancetype)initWithStartingDotRenderer:(id<CTDDotRenderer>)startingDotRenderer
                          endingDotRenderer:(id<CTDDotRenderer>)endingDotRenderer
                         connectionRenderer:(id<CTDDotConnectionRenderer>)connectionRenderer
                     trialStepStateObserver:(id<CTDTrialStepStateObserver>)trialStepStateObserver
{
    self = [super init];
    if (self) {
        _startingDotRenderer = startingDotRenderer;
        _endingDotRenderer = endingDotRenderer;
        _connectionRenderer = connectionRenderer;
        _trialStepStateObserver = trialStepStateObserver;
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
                                             connectionStateObserver:self
                                                   targetDotRenderer:_endingDotRenderer];
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

- (id)startingDotId
{
    return @1;
}

- (id)endingDotId
{
    return @2;
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
}

- (instancetype)initWithColorCellRenderers:(NSDictionary*)colorCellRenderers
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
        _selectedColor = CTDDotColor_None;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (id<CTDSelectionEditor>)editorForColorSelection
{
    CTDColorSelectionSetter selectionSetter = ^(CTDDotColor selectedColor)
    {
        if (selectedColor == self.selectedColor) { return; }

        if (self.selectedColor != CTDDotColor_None)
        {
            [self->_colorCells[@(self.selectedColor)] setSelected:NO];
        }
        if (selectedColor != CTDDotColor_None)
        {
            [self->_colorCells[@(selectedColor)] setSelected:YES];
        }
        self->_selectedColor = selectedColor;
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
