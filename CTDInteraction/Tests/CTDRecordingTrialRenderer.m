// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDRecordingTrialRenderer.h"

#import "CTDFakeDotRenderer.h"
#import "CTDRecordingDotConnectionView.h"
#import "ExtensionPoints/CTDTouchable.h"
#import "CTDPresentation/CTDColorPalette.h"
#import "CTDPresentation/CTDDotConnectionRenderer.h"
#import "CTDPresentation/CTDDotRenderer.h"
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
                                        withInitialColor:(CTDPaletteColorLabel)dotColor
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
