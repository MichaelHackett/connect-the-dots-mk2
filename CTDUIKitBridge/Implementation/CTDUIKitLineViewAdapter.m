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
    ctd_strongify(_lineView, lineView);
    lineView.firstEndpoint = [firstEndpointPosition asCGPoint];
}

- (void)setSecondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    ctd_strongify(_lineView, lineView);
    lineView.secondEndpoint = [secondEndpointPosition asCGPoint];
}

- (void)setVisible:(BOOL)visible
{
    ctd_strongify(_lineView, lineView);
    lineView.hidden = !visible;
}

- (void)discardRendering
{
    ctd_strongify(_lineView, lineView);
    _lineView = nil;
    [lineView removeFromSuperview];
}

@end
