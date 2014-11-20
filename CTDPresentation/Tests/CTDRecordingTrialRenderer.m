// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingTrialRenderer.h"

#import "CTDColorPalette.h"
#import "CTDDotConnectionRenderer.h"
#import "CTDDotRenderer.h"
#import "CTDFakeDotRenderer.h"
#import "CTDRecordingDotConnectionView.h"
#import "CTDTouchable.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDRecordingTrialRenderer
{
    NSMutableArray* _dotViewsCreated;
    NSMutableArray* _connectionViewsCreated;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dotViewsCreated = [[NSMutableArray alloc] init];
        _connectionViewsCreated = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray*)dotViewsCreated
{
    return [_dotViewsCreated copy];
}

- (NSArray*)connectionViewsCreated
{
    return [_connectionViewsCreated copy];
}

- (id<CTDDotRenderer, CTDTouchable>)newDotViewCenteredAt:(CTDPoint*)centerPosition
                                        withInitialColor:(CTDPaletteColor)dotColor
{
    id newDotView = [[CTDFakeDotRenderer alloc]
                     initWithCenterPosition:centerPosition
                                   dotColor:dotColor];
    [_dotViewsCreated addObject:newDotView];
    return newDotView;
}

- (id<CTDDotConnectionRenderer>)
      newDotConnectionViewWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
      secondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    id newConnectionView = [[CTDRecordingDotConnectionView alloc]
                                  initWithFirstEndpointPosition:firstEndpointPosition
                                  secondEndpointPosition:secondEndpointPosition];
    [_connectionViewsCreated addObject:newConnectionView];
    return newConnectionView;
}

@end
