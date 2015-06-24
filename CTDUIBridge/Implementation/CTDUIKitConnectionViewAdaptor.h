// CTDConnectionViewAdaptor:
//     Adapts CTDUIKitConnectionView to the CTDDotConnectionRenderer protocol.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDDotConnectionRenderer.h"

@class CTDUIKitConnectionView;



@interface CTDUIKitConnectionViewAdaptor : NSObject <CTDDotConnectionRenderer>

- (instancetype)initWithConnectionView:(CTDUIKitConnectionView*)connectionView;

@end
