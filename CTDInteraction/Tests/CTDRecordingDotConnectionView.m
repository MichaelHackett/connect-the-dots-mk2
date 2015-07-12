// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingDotConnectionView.h"

#import "CTDUtility/CTDPoint.h"



@implementation CTDRecordingDotConnectionView

- (instancetype)initWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                       secondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    self = [super init];
    if (self) {
        _firstEndpointPosition = [firstEndpointPosition copy];
        _secondEndpointPosition = [secondEndpointPosition copy];
    }
    return self;
}

- (void)setFirstEndpointPosition:(CTDPoint*)firstEndpointPosition {
    _firstEndpointPosition = [firstEndpointPosition copy];
}

- (void)setSecondEndpointPosition:(CTDPoint*)secondEndpointPosition {
    _secondEndpointPosition = [secondEndpointPosition copy];
}

- (void)invalidate {
    _invalidated = YES;
}

@end