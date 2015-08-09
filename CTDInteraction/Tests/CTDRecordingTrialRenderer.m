// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDRecordingTrialRenderer.h"

#import "CTDFakeDotRenderer.h"
#import "CTDRecordingDotConnectionRenderer.h"
#import "Ports/CTDTouchable.h"
#import "CTDApplication/Ports/CTDTrialRenderer.h"
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

- (id<CTDDotRenderer>)newRendererForDot
{
    id newDotRenderer = [[CTDFakeDotRenderer alloc] init];
    [_dotRenderersCreated addObject:newDotRenderer];
    return newDotRenderer;
}

- (id<CTDDotConnectionRenderer>)newRendererForDotConnection
{
    id newConnectionRenderer = [[CTDRecordingDotConnectionRenderer alloc] init];
    [_connectionRenderersCreated addObject:newConnectionRenderer];
    return newConnectionRenderer;
}

@end
