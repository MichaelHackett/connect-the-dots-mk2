// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingDotConnectionRenderer.h"

#import "CTDUtility/CTDPoint.h"



@implementation CTDRecordingDotConnectionRenderer

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _firstEndpointPosition = nil;
        _secondEndpointPosition = nil;
    }
    return self;
}

- (void)setFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
{
    _firstEndpointPosition = [firstEndpointPosition copy];
}

- (void)setSecondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    _secondEndpointPosition = [secondEndpointPosition copy];
}

- (void)setVisible:(__unused BOOL)visible
{
}

- (void)discardRendering
{
    _invalidated = YES;
}

@end
