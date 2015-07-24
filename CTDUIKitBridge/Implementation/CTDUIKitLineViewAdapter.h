// CTDUIKitLineViewAdapter:
//     Adapts CTDUIKitLineView to the CTDDotConnectionRenderer protocol.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDPresentation/Ports/CTDDotConnectionRenderer.h"

@class CTDUIKitLineView;



@interface CTDUIKitLineViewAdapter : NSObject <CTDDotConnectionRenderer>

- (instancetype)initWithLineView:(CTDUIKitLineView*)connectionView;

@end
