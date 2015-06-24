// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectionViewAdaptor.h"

#import "CTDUIKitConnectionView.h"
#import "CTDUtility/CTDPoint.h"
#import "CTDPoint+CGConversion.h"



@implementation CTDUIKitConnectionViewAdaptor
{
    __weak CTDUIKitConnectionView* _connectionView;
}

- (instancetype)initWithConnectionView:(CTDUIKitConnectionView*)connectionView
{
    self = [super init];
    if (self) {
        _connectionView = connectionView;
    }
    return self;
}



#pragma mark CTDDotConnectionRenderer protocol



- (void)setFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
{
    CTDUIKitConnectionView* strongConnectionView = _connectionView;
    strongConnectionView.firstEndpoint = [firstEndpointPosition asCGPoint];
}

- (void)setSecondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    CTDUIKitConnectionView* strongConnectionView = _connectionView;
    strongConnectionView.secondEndpoint = [secondEndpointPosition asCGPoint];
}

- (void)invalidate
{
    CTDUIKitConnectionView* strongConnectionView = _connectionView;
    _connectionView = nil;
    [strongConnectionView removeFromSuperview];
}

@end
