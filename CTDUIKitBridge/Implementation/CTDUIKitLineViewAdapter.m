// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitLineViewAdapter.h"

#import "CTDUIKitLineView.h"
#import "CTDUtility/CTDPoint.h"
#import "CTDPoint+CGConversion.h"



@implementation CTDUIKitLineViewAdapter
{
    __weak CTDUIKitLineView* _lineView;
}

- (instancetype)initWithLineView:(CTDUIKitLineView*)lineView
{
    self = [super init];
    if (self) {
        _lineView = lineView;
    }
    return self;
}



#pragma mark CTDDotConnectionRenderer protocol



- (void)setFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
{
    CTDUIKitLineView* strongLineView = _lineView;
    strongLineView.firstEndpoint = [firstEndpointPosition asCGPoint];
}

- (void)setSecondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    CTDUIKitLineView* strongLineView = _lineView;
    strongLineView.secondEndpoint = [secondEndpointPosition asCGPoint];
}

- (void)discardRendering
{
    CTDUIKitLineView* strongLineView = _lineView;
    _lineView = nil;
    [strongLineView removeFromSuperview];
}

@end
