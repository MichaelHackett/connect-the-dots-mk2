// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDRecordingTrialRenderer.h"

#import "CTDFakeDotRenderer.h"
#import "CTDRecordingDotConnectionRenderer.h"
#import "Ports/CTDTouchable.h"
#import "CTDPresentation/CTDColorPalette.h"
#import "CTDPresentation/Ports/CTDDotConnectionRenderer.h"
#import "CTDPresentation/Ports/CTDDotRenderer.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDRecordingTrialRenderer
{
    NSMutableArray* _dotRenderersCreated;
    NSMutableArray* _connectionRenderersCreated;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dotRenderersCreated = [[NSMutableArray alloc] init];
        _connectionRenderersCreated = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray*)dotRenderersCreated
{
    return [_dotRenderersCreated copy];
}

- (NSArray*)connectionRenderersCreated
{
    return [_connectionRenderersCreated copy];
}

- (id<CTDDotRenderer, CTDTouchable>)
      newRendererForDotWithCenterPosition:(CTDPoint *)centerPosition
                             initialColor:(CTDPaletteColorLabel)dotColor
{
    id newDotRenderer = [[CTDFakeDotRenderer alloc]
                         initWithCenterPosition:centerPosition
                                       dotColor:dotColor];
    [_dotRenderersCreated addObject:newDotRenderer];
    return newDotRenderer;
}

- (id<CTDDotConnectionRenderer>)
      newRendererForDotConnectionWithFirstEndpointPosition:(CTDPoint *)firstEndpointPosition
                                    secondEndpointPosition:(CTDPoint *)secondEndpointPosition
{
    id newConnectionRenderer = [[CTDRecordingDotConnectionRenderer alloc]
                                initWithFirstEndpointPosition:firstEndpointPosition
                                secondEndpointPosition:secondEndpointPosition];
    [_connectionRenderersCreated addObject:newConnectionRenderer];
    return newConnectionRenderer;
}

@end
